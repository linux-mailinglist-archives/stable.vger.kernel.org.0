Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E8043F80
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfFMP6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731500AbfFMIuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ABAC21473;
        Thu, 13 Jun 2019 08:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415823;
        bh=dOXVFBwfFnjr6mtGpP9lPz0BOq2tVCzrhnbNIxx+j28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIIgD+IiixlMiT9Y3mxC9YdAqaPtUBl/Plp00WPPbV8b3JWaNPAmAmvt/hkAuGNCP
         9DJQ18N7s7tpLJVaBneDB7uDhvylxMsyWik15fEW2M3UiGoT4Un1CQJf+roQ0wvpUV
         Z2RyFmK2MQ9blu4chl/jW2QBGuDEoultW1orxsT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 136/155] ice: Add missing case in print_link_msg for printing flow control
Date:   Thu, 13 Jun 2019 10:34:08 +0200
Message-Id: <20190613075700.329220104@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 203a068ac9e2722e4d118116acaa3a5586f9468a ]

Currently we aren't checking for the ICE_FC_NONE case for the current
flow control mode. This is causing "Unknown" to be printed for the
current flow control method if flow control is disabled. Fix this by
adding the case for ICE_FC_NONE to print "None".

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6ec73864019c..b562476b1251 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -528,6 +528,9 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	case ICE_FC_RX_PAUSE:
 		fc = "RX";
 		break;
+	case ICE_FC_NONE:
+		fc = "None";
+		break;
 	default:
 		fc = "Unknown";
 		break;
-- 
2.20.1



