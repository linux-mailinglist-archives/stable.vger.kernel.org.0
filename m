Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12C912CA38
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfL2RWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbfL2RWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:22:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4ED7207FD;
        Sun, 29 Dec 2019 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640168;
        bh=cGJoQaBLeDWQxSAkGHpykO2M28PK5xPPF5XrwpBF+GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lnw4DO42JVya9yN+hiyk5AaFQQd47UZHS1GM0iJMGH37nolRpoL4SP4REm7bl9LhF
         XuPTCrMudCbvdYNgWHPmYiJiD2OlElzxLYZpX33c237jYDCWFuQgQ3uVyhBlSq8oFy
         NiH7Jrb5nqXUTIhoD7lROwRdtAImCSDnKWtg+teI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 039/161] selftests/bpf: Correct path to include msg + path
Date:   Sun, 29 Dec 2019 18:18:07 +0100
Message-Id: <20191229162411.621058361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit c588146378962786ddeec817f7736a53298a7b01 ]

The "path" buf is supposed to contain path + printf msg up to 24 bytes.
It will be cut anyway, but compiler generates truncation warns like:

"
samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c: In
function ‘setup_cgroup_environment’:
samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:52:34:
warning: ‘/cgroup.controllers’ directive output may be truncated
writing 19 bytes into a region of size between 1 and 4097
[-Wformat-truncation=]
snprintf(path, sizeof(path), "%s/cgroup.controllers", cgroup_path);
				  ^~~~~~~~~~~~~~~~~~~
samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:52:2:
note: ‘snprintf’ output between 20 and 4116 bytes into a destination
of size 4097
snprintf(path, sizeof(path), "%s/cgroup.controllers", cgroup_path);
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:72:34:
warning: ‘/cgroup.subtree_control’ directive output may be truncated
writing 23 bytes into a region of size between 1 and 4097
[-Wformat-truncation=]
snprintf(path, sizeof(path), "%s/cgroup.subtree_control",
				  ^~~~~~~~~~~~~~~~~~~~~~~
cgroup_path);
samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:72:2:
note: ‘snprintf’ output between 24 and 4120 bytes into a destination
of size 4097
snprintf(path, sizeof(path), "%s/cgroup.subtree_control",
cgroup_path);
"

In order to avoid warns, lets decrease buf size for cgroup workdir on
24 bytes with assumption to include also "/cgroup.subtree_control" to
the address. The cut will never happen anyway.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20191002120404.26962-3-ivan.khoronzhuk@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/cgroup_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/cgroup_helpers.c b/samples/bpf/cgroup_helpers.c
index 09afaddfc9ba..b5c09cd6c7bd 100644
--- a/samples/bpf/cgroup_helpers.c
+++ b/samples/bpf/cgroup_helpers.c
@@ -43,7 +43,7 @@
  */
 int setup_cgroup_environment(void)
 {
-	char cgroup_workdir[PATH_MAX + 1];
+	char cgroup_workdir[PATH_MAX - 24];
 
 	format_cgroup_path(cgroup_workdir, "");
 
-- 
2.20.1



