Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB07F1482F3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404420AbgAXLcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404415AbgAXLcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:12 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FAB820718;
        Fri, 24 Jan 2020 11:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865532;
        bh=KVgqGjNoLZRazY75M8fXlXs5zunKSvCyQQ6687cSFQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjC20xSFjHZHO82K5HgKAjgkYx+eEKe+1Qi4DGzVRxdCthy1lpE+QxeIym2AGGtry
         BLaY+fHwyVDzz1S/fop+ik96eai4G2+5yerQVP6hV06GM9Lo3lZZ1w6LxUbJO1enXx
         jOQ1HLIBsJtOmKdUIMtKHKDYXglXal34zkXpBxu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 571/639] bpf: fix BTF limits
Date:   Fri, 24 Jan 2020 10:32:21 +0100
Message-Id: <20200124093200.913888334@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit a0791f0df7d212c245761538b17a9ea93607b667 ]

vmlinux BTF has more than 64k types.
Its string section is also at the offset larger than 64k.
Adjust both limits to make in-kernel BTF verifier successfully parse in-kernel BTF.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/btf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 972265f328717..1e2662ff05291 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -22,9 +22,9 @@ struct btf_header {
 };
 
 /* Max # of type identifier */
-#define BTF_MAX_TYPE	0x0000ffff
+#define BTF_MAX_TYPE	0x000fffff
 /* Max offset into the string section */
-#define BTF_MAX_NAME_OFFSET	0x0000ffff
+#define BTF_MAX_NAME_OFFSET	0x00ffffff
 /* Max # of struct/union/enum members or func args */
 #define BTF_MAX_VLEN	0xffff
 
-- 
2.20.1



