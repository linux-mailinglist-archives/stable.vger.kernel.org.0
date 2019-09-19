Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26B5B874F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405317AbfISWHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405313AbfISWHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 376E821907;
        Thu, 19 Sep 2019 22:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930870;
        bh=1mpdEmxlulUxMm5dMbUBfyxVH2N8bAtQhPgQoAI14Lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLSbbhJGip5XGHETyaJSsbFHjb49IzkwomK6xsLo0ORJVGp3bEGYqoJmv7dWvva4r
         6DaQbCrJolWMR+1Ss37Tp7rRAXQbbMkL72j4x72haT7ispRwkfUqyvW96e341mZL95
         zIyLCX7duZm6/1fB4hPYuu+AfwtmdgAFQZ2VZb8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 045/124] tools: bpftool: close prog FD before exit on showing a single program
Date:   Fri, 20 Sep 2019 00:02:13 +0200
Message-Id: <20190919214820.643391357@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit d34b044038bfb0e19caa8b019910efc465f41d5f ]

When showing metadata about a single program by invoking
"bpftool prog show PROG", the file descriptor referring to the program
is not closed before returning from the function. Let's close it.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 7a4e21a315236..d41651afe5f64 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -362,7 +362,9 @@ static int do_show(int argc, char **argv)
 		if (fd < 0)
 			return -1;
 
-		return show_prog(fd);
+		err = show_prog(fd);
+		close(fd);
+		return err;
 	}
 
 	if (argc)
-- 
2.20.1



