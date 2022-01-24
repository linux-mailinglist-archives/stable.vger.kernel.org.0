Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7389F49A2A8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365909AbiAXXv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587682AbiAXW4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C29C055AB9;
        Mon, 24 Jan 2022 13:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5542A612E9;
        Mon, 24 Jan 2022 21:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E74C340E5;
        Mon, 24 Jan 2022 21:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058690;
        bh=EjYjonRQitSknKhd+4bksVPMqHt1V78cIUfxjZQC6x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqmrEQ0lA+GZgDVofYxvIol4+SCyesyj1f0UsiTN5uMDA25z/QeZQ38ENdo+HvxYz
         v01+6lx2lTo49My9PqBXLyF3gcSCb4PuMj2UHcu/ykZz7diw2JEyHgJFO2FF5NXkyp
         bVocoyqZTwPZfSjy3Clta3zKOCcrGGRi2iWEI9y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0338/1039] um: virt-pci: Fix 32-bit compile
Date:   Mon, 24 Jan 2022 19:35:27 +0100
Message-Id: <20220124184136.668044062@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d73820df6437b5d0a57be53faf39db46a0264b3a ]

There were a few 32-bit compile warnings that of course
turned into errors with -Werror, fix the 32-bit build.

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index c080666330234..0ab58016db22f 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -181,15 +181,15 @@ static unsigned long um_pci_cfgspace_read(void *priv, unsigned int offset,
 	/* buf->data is maximum size - we may only use parts of it */
 	struct um_pci_message_buffer *buf;
 	u8 *data;
-	unsigned long ret = ~0ULL;
+	unsigned long ret = ULONG_MAX;
 
 	if (!dev)
-		return ~0ULL;
+		return ULONG_MAX;
 
 	buf = get_cpu_var(um_pci_msg_bufs);
 	data = buf->data;
 
-	memset(data, 0xff, sizeof(data));
+	memset(buf->data, 0xff, sizeof(buf->data));
 
 	switch (size) {
 	case 1:
@@ -304,7 +304,7 @@ static unsigned long um_pci_bar_read(void *priv, unsigned int offset,
 	/* buf->data is maximum size - we may only use parts of it */
 	struct um_pci_message_buffer *buf;
 	u8 *data;
-	unsigned long ret = ~0ULL;
+	unsigned long ret = ULONG_MAX;
 
 	buf = get_cpu_var(um_pci_msg_bufs);
 	data = buf->data;
-- 
2.34.1



