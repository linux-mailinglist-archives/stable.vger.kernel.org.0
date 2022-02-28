Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703554C75EF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiB1R5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbiB1Rwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:52:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC21493194;
        Mon, 28 Feb 2022 09:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AAE56156B;
        Mon, 28 Feb 2022 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E050C340F0;
        Mon, 28 Feb 2022 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069986;
        bh=0Dr3gRhH+CgEtiZ4s/Z9cMlnUNTk/O/bL+ukYHRkZDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+23RmiBYdt4UYhJTRscaeGIUiwykOW7CGjnB3N/FHJwaoUdso2A6B51V8v7c0bjF
         bLOu+0OLtnmyrJJDVCuVPfv4wymN1qKE3hSTiAcEx7t6RCgqTwNZvgaDS6AICZhQ64
         qtbI/8xTbiejoKrGPnvYgaAAnMGYHTqLM+dhofgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 047/139] ice: check the return of ice_ptp_gettimex64
Date:   Mon, 28 Feb 2022 18:23:41 +0100
Message-Id: <20220228172352.632165828@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit ed22d9c8d128293fc7b0b086c7d3654bcb99a8dd upstream.

Clang static analysis reports this issue
time64.h:69:50: warning: The left operand of '+'
  is a garbage value
  set_normalized_timespec64(&ts_delta, lhs.tv_sec + rhs.tv_sec,
                                       ~~~~~~~~~~ ^
In ice_ptp_adjtime_nonatomic(), the timespec64 variable 'now'
is set by ice_ptp_gettimex64().  This function can fail
with -EBUSY, so 'now' can have a gargbage value.
So check the return.

Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -846,9 +846,12 @@ exit:
 static int ice_ptp_adjtime_nonatomic(struct ptp_clock_info *info, s64 delta)
 {
 	struct timespec64 now, then;
+	int ret;
 
 	then = ns_to_timespec64(delta);
-	ice_ptp_gettimex64(info, &now, NULL);
+	ret = ice_ptp_gettimex64(info, &now, NULL);
+	if (ret)
+		return ret;
 	now = timespec64_add(now, then);
 
 	return ice_ptp_settime64(info, (const struct timespec64 *)&now);


