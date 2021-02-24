Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85012323D0D
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhBXNCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235325AbhBXM5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:57:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2AB064EF1;
        Wed, 24 Feb 2021 12:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171134;
        bh=c8X0HV894pJBiANVg6efLkwkO+ReRjB5fQ/es0cqU5k=;
        h=From:To:Cc:Subject:Date:From;
        b=gPkxxnI9xQTlTBcT+D7wIG4PBaVkChFsYtLBPwgsUb9Ij/HObjpixYdh78yDbms8K
         XgKVbET1421clMM7VptIwGBBOzgjyknbh8hE7jYTfJPOp7TWZ6QUIHPQb91VIWj8pi
         6nBTgUhUWRfXl2QfBUtYmDRHK9ldZEWSxhePqPQePxVGJTth7IODlqBhC6O1NziijQ
         /6T66wiqbo0/frXyLuXxM53zv0d62Nd0zr5ZcW9gd4tD5ANR1mPLFNFSyc7b10r4r6
         RUFi+fisB5vt1KwMDS0uWRyTulN2iysZf5MzAHHQRn8yjg4Q60Bkl/t6FJSD7xlT+N
         DNKE4zcrJf9uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Don Curtis <bugrprt21882@online.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/56] EDAC/amd64: Do not load on family 0x15, model 0x13
Date:   Wed, 24 Feb 2021 07:51:17 -0500
Message-Id: <20210224125212.482485-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 6c13d7ff81e6d2f01f62ccbfa49d1b8d87f274d0 ]

Those were only laptops and are very very unlikely to have ECC memory.
Currently, when the driver attempts to load, it issues:

  EDAC amd64: Error: F1 not found: device 0x1601 (broken BIOS?)

because the PCI device is the wrong one (it uses the F15h default one).

So do not load the driver on them as that is pointless.

Reported-by: Don Curtis <bugrprt21882@online.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Don Curtis <bugrprt21882@online.de>
Link: http://bugzilla.opensuse.org/show_bug.cgi?id=1179763
Link: https://lkml.kernel.org/r/20201218160622.20146-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 620f7041db6b5..b36d5879b91e0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3350,10 +3350,13 @@ static struct amd64_family_type *per_family_init(struct amd64_pvt *pvt)
 			fam_type = &family_types[F15_M60H_CPUS];
 			pvt->ops = &family_types[F15_M60H_CPUS].ops;
 			break;
+		/* Richland is only client */
+		} else if (pvt->model == 0x13) {
+			return NULL;
+		} else {
+			fam_type	= &family_types[F15_CPUS];
+			pvt->ops	= &family_types[F15_CPUS].ops;
 		}
-
-		fam_type	= &family_types[F15_CPUS];
-		pvt->ops	= &family_types[F15_CPUS].ops;
 		break;
 
 	case 0x16:
@@ -3547,6 +3550,7 @@ static int probe_one_instance(unsigned int nid)
 	pvt->mc_node_id	= nid;
 	pvt->F3 = F3;
 
+	ret = -ENODEV;
 	fam_type = per_family_init(pvt);
 	if (!fam_type)
 		goto err_enable;
-- 
2.27.0

