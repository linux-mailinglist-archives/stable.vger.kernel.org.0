Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B3317FB29
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbgCJNLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:32852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731412AbgCJNLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD27724649;
        Tue, 10 Mar 2020 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845883;
        bh=Uvu0WyXXGIrdFGCDU96MKnZBJOtUvwGuyAPktazVLOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17ME2voKTVwqDBCMaosX54iGK1238FysZqbfCvU4WGV9CyCeGzktiwEJa5gUkhbuM
         rageMFZPdZabS0uEFEGylRAQqal4WZAwgcbV0vvhr7uTC4Sh0AB7EtX5MIH7EYASqh
         yuq5LNGbj53/i/zgkMpnOzOy9yxH/AJMD+OryGDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/86] EDAC/amd64: Set grain per DIMM
Date:   Tue, 10 Mar 2020 13:44:25 +0100
Message-Id: <20200310124530.890506153@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 466503d6b1b33be46ab87c6090f0ade6c6011cbc ]

The following commit introduced a warning on error reports without a
non-zero grain value.

  3724ace582d9 ("EDAC/mc: Fix grain_bits calculation")

The amd64_edac_mod module does not provide a value, so the warning will
be given on the first reported memory error.

Set the grain per DIMM to cacheline size (64 bytes). This is the current
recommendation.

Fixes: 3724ace582d9 ("EDAC/mc: Fix grain_bits calculation")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robert Richter <rrichter@marvell.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20191022203448.13962-7-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 94265e4385146..05d6f9c86ac38 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2863,6 +2863,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 			dimm = csrow->channels[j]->dimm;
 			dimm->mtype = pvt->dram_type;
 			dimm->edac_mode = edac_mode;
+			dimm->grain = 64;
 		}
 	}
 
-- 
2.20.1



