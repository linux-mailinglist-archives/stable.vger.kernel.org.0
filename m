Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF7A420BB7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhJDM70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhJDM6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D7D613D5;
        Mon,  4 Oct 2021 12:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352186;
        bh=58RFKXXViAzwwCwE5+5j36GGL2p24I8CoD7yBiR3tKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpRaHrEb8ZvPCl08tXCxADPv+GhkFq+TRG1TxS0HKmtqsFHriCnooctWvzsp231+b
         KPWGyGKtmpOyOVnnI1ShZgQlcqjEt10utbgGKCftTo6UXIpU5y/pV3XJWGmsmPBGxw
         XnkeG8EwINLKinA4lx/4wJ69k8XIPIqek0nouJUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/57] sparc: avoid stringop-overread errors
Date:   Mon,  4 Oct 2021 14:52:07 +0200
Message-Id: <20211004125029.669554088@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit fc7c028dcdbfe981bca75d2a7b95f363eb691ef3 ]

The sparc mdesc code does pointer games with 'struct mdesc_hdr', but
didn't describe to the compiler how that header is then followed by the
data that the header describes.

As a result, gcc is now unhappy since it does stricter pointer range
tracking, and doesn't understand about how these things work.  This
results in various errors like:

    arch/sparc/kernel/mdesc.c: In function ‘mdesc_node_by_name’:
    arch/sparc/kernel/mdesc.c:647:22: error: ‘strcmp’ reading 1 or more bytes from a region of size 0 [-Werror=stringop-overread]
      647 |                 if (!strcmp(names + ep[ret].name_offset, name))
          |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

which are easily avoided by just describing 'struct mdesc_hdr' better,
and making the node_block() helper function look into that unsized
data[] that follows the header.

This makes the sparc64 build happy again at least for my cross-compiler
version (gcc version 11.2.1).

Link: https://lore.kernel.org/lkml/CAHk-=wi4NW3NC0xWykkw=6LnjQD6D_rtRtxY9g8gQAJXtQMi8A@mail.gmail.com/
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/mdesc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 8a6982dfd733..5aa33bf7139e 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -37,6 +37,7 @@ struct mdesc_hdr {
 	u32	node_sz; /* node block size */
 	u32	name_sz; /* name block size */
 	u32	data_sz; /* data block size */
+	char	data[];
 } __attribute__((aligned(16)));
 
 struct mdesc_elem {
@@ -369,7 +370,7 @@ out:
 
 static struct mdesc_elem *node_block(struct mdesc_hdr *mdesc)
 {
-	return (struct mdesc_elem *) (mdesc + 1);
+	return (struct mdesc_elem *) mdesc->data;
 }
 
 static void *name_block(struct mdesc_hdr *mdesc)
-- 
2.33.0



