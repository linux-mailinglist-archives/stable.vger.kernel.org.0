Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6967259749
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbgIAQMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgIAPgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:36:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C323120E65;
        Tue,  1 Sep 2020 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974595;
        bh=HoRWHVr2nxkcyHpWx7uSIErrJ+zEm+ycisSWs6Uvf6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuNg3msSAd5rDQel260QP5UnSeCV5gO/WYS8rLTHERAxnQ4+k/BzeH4RrkKB/FQXN
         HeTSwsB5LWR7lFTZZZLvG5R194anm9Wfl0bJcuS8nOJbwdfv5VJ3qxFVQKNUvl1hkl
         bM9ubZStr0WVSQgM78vfeaEscHqPuToIPesNyPX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 008/255] EDAC/mc: Call edac_inc_ue_error() before panic
Date:   Tue,  1 Sep 2020 17:07:44 +0200
Message-Id: <20200901151001.208409831@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit e9ff6636d3f97a764487999754c0bfee9d2c231e ]

By calling edac_inc_ue_error() before panic, we get a correct UE error
count for core dump analysis.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20200610065846.3626-2-zhenzhong.duan@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 5813e931f2f00..01ff71f7b6456 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -950,6 +950,8 @@ static void edac_ue_error(struct edac_raw_error_desc *e)
 			e->other_detail);
 	}
 
+	edac_inc_ue_error(e);
+
 	if (edac_mc_get_panic_on_ue()) {
 		panic("UE %s%son %s (%s page:0x%lx offset:0x%lx grain:%ld%s%s)\n",
 			e->msg,
@@ -959,8 +961,6 @@ static void edac_ue_error(struct edac_raw_error_desc *e)
 			*e->other_detail ? " - " : "",
 			e->other_detail);
 	}
-
-	edac_inc_ue_error(e);
 }
 
 static void edac_inc_csrow(struct edac_raw_error_desc *e, int row, int chan)
-- 
2.25.1



