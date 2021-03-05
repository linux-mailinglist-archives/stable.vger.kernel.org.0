Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0132E8FE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhCEMaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231828AbhCEM3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1A465019;
        Fri,  5 Mar 2021 12:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947371;
        bh=MzECXvRCfTdhhl662iinpmpj+CqmNMIktdP22PxNuuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m79fP7WukIdJBMzj7bM6dInL3wj7EAWfFU32d3VUUXgMRvom7/pvFBCUx0HkjWqQ0
         HKADr94bPhJaMelOF6IzmgTfN5h/ZY+0WFxjGASsabxXqoXEfE1JJrhJVMzH89Agge
         1+UGaOqDCAuKpxZDkyMEeKdtEq30RHOfz1IUnngs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Don Curtis <bugrprt21882@online.de>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/102] EDAC/amd64: Do not load on family 0x15, model 0x13
Date:   Fri,  5 Mar 2021 13:20:59 +0100
Message-Id: <20210305120905.265204467@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 620f7041db6b..b36d5879b91e 100644
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
2.30.1



