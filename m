Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F25215C160
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgBMPWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgBMPWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:55 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26142469C;
        Thu, 13 Feb 2020 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607374;
        bh=dpTkv8HVSAVvf6QfxVo1vDlo0mkFLI2SdHbCz0UscQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BERZPEVGFZOxaubFkW1IqlyO+YE/Pwm/THPMfQu+qEDPSwMnWnQxPYqzfNvzDa1G
         KA5Omtr5PLD/M7Q3TLR/QThdSfiLxCOyjCihrMkyBWEuss7Zg9b251tcZoiTNw7k13
         6b81Bwsb2ACKXIgMyGM3R/vt+VTSJ+DUu8qgW2HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 68/91] KVM: x86: drop picdev_in_range()
Date:   Thu, 13 Feb 2020 07:20:25 -0800
Message-Id: <20200213151848.473052412@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 9fecaa9e32ae7370878e5967d8874b6f58360b10 ]

We already have the exact same checks a couple of lines below.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/i8259.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 7cc2360f1848e..ce0f29e5d7c43 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -456,46 +456,33 @@ static u32 elcr_ioport_read(void *opaque, u32 addr1)
 	return s->elcr;
 }
 
-static int picdev_in_range(gpa_t addr)
-{
-	switch (addr) {
-	case 0x20:
-	case 0x21:
-	case 0xa0:
-	case 0xa1:
-	case 0x4d0:
-	case 0x4d1:
-		return 1;
-	default:
-		return 0;
-	}
-}
-
 static int picdev_write(struct kvm_pic *s,
 			 gpa_t addr, int len, const void *val)
 {
 	unsigned char data = *(unsigned char *)val;
-	if (!picdev_in_range(addr))
-		return -EOPNOTSUPP;
 
 	if (len != 1) {
 		pr_pic_unimpl("non byte write\n");
 		return 0;
 	}
-	pic_lock(s);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
 	case 0xa0:
 	case 0xa1:
+		pic_lock(s);
 		pic_ioport_write(&s->pics[addr >> 7], addr, data);
+		pic_unlock(s);
 		break;
 	case 0x4d0:
 	case 0x4d1:
+		pic_lock(s);
 		elcr_ioport_write(&s->pics[addr & 1], addr, data);
+		pic_unlock(s);
 		break;
+	default:
+		return -EOPNOTSUPP;
 	}
-	pic_unlock(s);
 	return 0;
 }
 
@@ -503,29 +490,31 @@ static int picdev_read(struct kvm_pic *s,
 		       gpa_t addr, int len, void *val)
 {
 	unsigned char data = 0;
-	if (!picdev_in_range(addr))
-		return -EOPNOTSUPP;
 
 	if (len != 1) {
 		memset(val, 0, len);
 		pr_pic_unimpl("non byte read\n");
 		return 0;
 	}
-	pic_lock(s);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
 	case 0xa0:
 	case 0xa1:
+		pic_lock(s);
 		data = pic_ioport_read(&s->pics[addr >> 7], addr);
+		pic_unlock(s);
 		break;
 	case 0x4d0:
 	case 0x4d1:
+		pic_lock(s);
 		data = elcr_ioport_read(&s->pics[addr & 1], addr);
+		pic_unlock(s);
 		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 	*(unsigned char *)val = data;
-	pic_unlock(s);
 	return 0;
 }
 
-- 
2.20.1



