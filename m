Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2E35BDE2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhDLI4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238315AbhDLIxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F031E6109E;
        Mon, 12 Apr 2021 08:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217492;
        bh=df6Rd755LKm4Brq3oACAw5MjiDAk5KfTbpVgDpAeEkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCxXXMPW0azW2DsWfX/zrTkzj990Yh19zTg7CW3S+uB5aPSk2jSY7v40OeSNtBi0k
         IKbcCqetw/h7LmUifZiqDLsTcOHRwFSydigxhMCoIu7P1NTXsUyxUnYHKHElYrZM8N
         QZgSVsHwnOdDt9gam5/nX1bwwmG5/7Qd+5rbLVDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 036/188] ice: fix memory allocation call
Date:   Mon, 12 Apr 2021 10:39:10 +0200
Message-Id: <20210412084014.849885768@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

commit 59df14f9cc2326bd6432d60eca0df8201d9d3d4b upstream.

Fix the order of number of array members and member size parameters in a
*calloc() call.

Fixes: b3c3890489f6 ("ice: avoid unnecessary single-member variable-length structs")
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -717,8 +717,8 @@ static enum ice_status ice_cfg_fw_log(st
 
 			if (!data) {
 				data = devm_kcalloc(ice_hw_to_dev(hw),
-						    sizeof(*data),
 						    ICE_AQC_FW_LOG_ID_MAX,
+						    sizeof(*data),
 						    GFP_KERNEL);
 				if (!data)
 					return ICE_ERR_NO_MEMORY;


