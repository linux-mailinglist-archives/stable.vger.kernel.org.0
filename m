Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BDB323C24
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhBXMvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhBXMvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D13C64E6F;
        Wed, 24 Feb 2021 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171030;
        bh=A2GUGgxB6CPesNTdDb+4GD+I5pFzSBZZmn8cu7Upo0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQFBDOFh+jJDrGycsck7os3WVx1kAW0JYGiEc3/R6VMFjjGAVnEj7tVXJP56zG4AB
         ZVNYn2uAEdsdMGu/u8/mFh/USK7txp6P2NBkHTNQUTYmuS2dmpP5RXENUQPX8AzcUV
         LQlTNtHF9rBewRYrzBsLkh79AzsoqZZwNOrpFYsNvQ7SQsEfH4+/9Yem1VY1ro6VcF
         MG06CxqOFhk3jKceUfxdC9YoZ1ENnEIaQFvAbqh5nXPN+HuyQwV9/I95FzXUvGoaZK
         ipNjYH/QtDeQ2JY24KMXCNk6JyU9HVpkRPhzuyYDWZnxcPKEh1Z90T4U3YecDIHR55
         S+ZbiBaprEF7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Don Curtis <bugrprt21882@online.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 02/67] EDAC/amd64: Do not load on family 0x15, model 0x13
Date:   Wed, 24 Feb 2021 07:49:20 -0500
Message-Id: <20210224125026.481804-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index f7087ddddb902..5754f429a8d2d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3342,10 +3342,13 @@ static struct amd64_family_type *per_family_init(struct amd64_pvt *pvt)
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
@@ -3539,6 +3542,7 @@ static int probe_one_instance(unsigned int nid)
 	pvt->mc_node_id	= nid;
 	pvt->F3 = F3;
 
+	ret = -ENODEV;
 	fam_type = per_family_init(pvt);
 	if (!fam_type)
 		goto err_enable;
-- 
2.27.0

