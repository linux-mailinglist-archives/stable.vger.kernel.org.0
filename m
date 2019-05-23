Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9022528771
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbfEWTTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389828AbfEWTTa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35035205ED;
        Thu, 23 May 2019 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639169;
        bh=EhYtP/rpvE8jWFvUYVqzJ7BQ2mvQOotty2PPRp7l7Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IooAF2xcGjpdlMVWCVLqyGNkeb6s4E8E98mBU2qsv7+LNks/ylkEwt+wx86X4ZkAU
         bAh2bOXXN7VhUXW7l3tJB4nZ6Xk9Jp8ASLVdFl0iuOoxyqtnKxwkU044SUxLwuG7JR
         hDQpHvBEEYigtwqRxyYkjySVlVZbzXkZsggHrf78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 112/114] bpf: relax inode permission check for retrieving bpf program
Date:   Thu, 23 May 2019 21:06:51 +0200
Message-Id: <20190523181740.846294896@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenbo Feng <fengc@google.com>

commit e547ff3f803e779a3898f1f48447b29f43c54085 upstream.

For iptable module to load a bpf program from a pinned location, it
only retrieve a loaded program and cannot change the program content so
requiring a write permission for it might not be necessary.
Also when adding or removing an unrelated iptable rule, it might need to
flush and reload the xt_bpf related rules as well and triggers the inode
permission check. It might be better to remove the write premission
check for the inode so we won't need to grant write access to all the
processes that flush and restore iptables rules.

Signed-off-by: Chenbo Feng <fengc@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -518,7 +518,7 @@ out:
 static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type type)
 {
 	struct bpf_prog *prog;
-	int ret = inode_permission(inode, MAY_READ | MAY_WRITE);
+	int ret = inode_permission(inode, MAY_READ);
 	if (ret)
 		return ERR_PTR(ret);
 


