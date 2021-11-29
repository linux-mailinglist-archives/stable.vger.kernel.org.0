Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E1E461F69
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379724AbhK2SrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379808AbhK2So7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B89DB8163A;
        Mon, 29 Nov 2021 18:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FFAC53FAD;
        Mon, 29 Nov 2021 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211299;
        bh=BUup2Qyu2L7dbIoGQj0zMjwvZ4/jKXSSOvxJaLxnQdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd4lB6uyfrnaRVIdOW0wGdo31XmTrxlPaUZ4BpkPHz+WGrcI4w7/FdDRTBnZu79qe
         TRgDAHoEmj5LdIAdOnXOcoNWv4v5TXvgfRA9sZAeNnkrg1eBUkYg+XtpHCuRDdgSe6
         KRQda3/6oxQnI5+jFyGt/SnAp9NrgAadX6I3kH+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.15 173/179] firmware: arm_scmi: Fix type error assignment in voltage protocol
Date:   Mon, 29 Nov 2021 19:19:27 +0100
Message-Id: <20211129181724.629780985@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

commit 026d9835b62bba34b7e657a0bfb76717822f9319 upstream.

Fix incorrect type assignment error reported by sparse as:

drivers/firmware/arm_scmi/voltage.c:159:42: warning: incorrect type in assignment (different base types)
drivers/firmware/arm_scmi/voltage.c:159:42: expected restricted __le32 [usertype] level_index
drivers/firmware/arm_scmi/voltage.c:159:42: got unsigned int [usertype] desc_index

Link: https://lore.kernel.org/r/20211115154043.49284-1-cristian.marussi@arm.com
Fixes: 2add5cacff353 ("firmware: arm_scmi: Add voltage domain management protocol support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/voltage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/arm_scmi/voltage.c
+++ b/drivers/firmware/arm_scmi/voltage.c
@@ -156,7 +156,7 @@ static int scmi_voltage_descriptors_get(
 			int cnt;
 
 			cmd->domain_id = cpu_to_le32(v->id);
-			cmd->level_index = desc_index;
+			cmd->level_index = cpu_to_le32(desc_index);
 			ret = ph->xops->do_xfer(ph, tl);
 			if (ret)
 				break;


