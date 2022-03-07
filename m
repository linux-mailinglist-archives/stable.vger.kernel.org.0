Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD694CF64E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbiCGJfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbiCGJdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:33:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7157A6D38B;
        Mon,  7 Mar 2022 01:30:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D8E61119;
        Mon,  7 Mar 2022 09:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2510DC340E9;
        Mon,  7 Mar 2022 09:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645442;
        bh=0XM5ZexUMskW4ZkOyUw7cgz87x2gisU6TaKUIornEEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prVpmwuLgIooonbIepHM5R4nCKar+VYa+QwRltxUO8GtROqW4x0T/8m+EOEBiB4GL
         /LmoNR4Wan3OcbhSb/sO+UboaqdV/t1QW157tW6NcomarZ4IRJgdsVCmXAGTInGsOA
         NnS9Ra/0TmrrChIODtxha+1MKoezJ8yI2BrYWQm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 033/105] thermal: core: Fix TZ_GET_TRIP NULL pointer dereference
Date:   Mon,  7 Mar 2022 10:18:36 +0100
Message-Id: <20220307091645.116487211@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

commit 5838a14832d447990827d85e90afe17e6fb9c175 upstream.

Do not call get_trip_hyst() from thermal_genl_cmd_tz_get_trip() if
the thermal zone does not define one.

Fixes: 1ce50e7d408e ("thermal: core: genetlink support for events/cmd/sampling")
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -418,11 +418,12 @@ static int thermal_genl_cmd_tz_get_trip(
 	for (i = 0; i < tz->trips; i++) {
 
 		enum thermal_trip_type type;
-		int temp, hyst;
+		int temp, hyst = 0;
 
 		tz->ops->get_trip_type(tz, i, &type);
 		tz->ops->get_trip_temp(tz, i, &temp);
-		tz->ops->get_trip_hyst(tz, i, &hyst);
+		if (tz->ops->get_trip_hyst)
+			tz->ops->get_trip_hyst(tz, i, &hyst);
 
 		if (nla_put_u32(msg, THERMAL_GENL_ATTR_TZ_TRIP_ID, i) ||
 		    nla_put_u32(msg, THERMAL_GENL_ATTR_TZ_TRIP_TYPE, type) ||


