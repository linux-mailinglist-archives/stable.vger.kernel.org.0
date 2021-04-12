Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F835BD00
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbhDLIqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237851AbhDLIqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 296986109E;
        Mon, 12 Apr 2021 08:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217150;
        bh=09ooUlwISxVla7TfWvf2JNWFhCcK81tqCeJIgvfv0gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuiLERD701IhQ5OnzuZfsa3kbzUGl+cwgANZOx/ch8spTjE4bhnbYP7ORAPQDGoiC
         lT87eUpVRgPD2LFpfBy1kJJat63SdAqCVoZpZz/mE7a7SPh3rb3EqHi8VcV2RuO/Cm
         uD4Pe2ojOrrM3Zje/VRFk4RHWjcfdEflI/GG7P7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Pricoco <fabio.pricoco@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 022/111] ice: Increase control queue timeout
Date:   Mon, 12 Apr 2021 10:40:00 +0200
Message-Id: <20210412084004.961222235@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Pricoco <fabio.pricoco@intel.com>

commit f88c529ac77b3c21819d2cf1dfcfae1937849743 upstream.

250 msec timeout is insufficient for some AQ commands. Advice from FW
team was to increase the timeout. Increase to 1 second.

Fixes: 7ec59eeac804 ("ice: Add support for control queues")
Signed-off-by: Fabio Pricoco <fabio.pricoco@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_controlq.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -31,8 +31,8 @@ enum ice_ctl_q {
 	ICE_CTL_Q_MAILBOX,
 };
 
-/* Control Queue timeout settings - max delay 250ms */
-#define ICE_CTL_Q_SQ_CMD_TIMEOUT	2500  /* Count 2500 times */
+/* Control Queue timeout settings - max delay 1s */
+#define ICE_CTL_Q_SQ_CMD_TIMEOUT	10000 /* Count 10000 times */
 #define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
 
 struct ice_ctl_q_ring {


