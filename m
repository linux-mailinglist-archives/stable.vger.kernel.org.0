Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDA4B49F8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346115AbiBNKRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346274AbiBNKPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E147B561;
        Mon, 14 Feb 2022 01:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C46E0B80DC8;
        Mon, 14 Feb 2022 09:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F1DC340E9;
        Mon, 14 Feb 2022 09:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832358;
        bh=PJHeGXva5+VseX84sjTYD+TkWsdaeyJBakqXYhk9zg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1SXIjjjibVtD3tayCiI7Kf1wh2A1pw+SUccf9ZUXPO0IMYGN4veb80SbNwZcmygN
         G3lp2+x9K/opuQOXKVIUARmURpQ3sIS6BqtBl0ozBhKOiVuPhAfn6QxubiZZLGWaHq
         Ic+CNlKFnX3+h90HiN5E3zhkpF1k3Pi3vxMY63o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 160/172] s390/cio: verify the driver availability for path_event call
Date:   Mon, 14 Feb 2022 10:26:58 +0100
Message-Id: <20220214092511.914738642@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit dd9cb842fa9d90653a9b48aba52f89c069f3bc50 upstream.

If no driver is attached to a device or the driver does not provide the
path_event function, an FCES path-event on this device could end up in a
kernel-panic. Verify the driver availability before the path_event
function call.

Fixes: 32ef938815c1 ("s390/cio: Add support for FCES status notification")
Cc: stable@vger.kernel.org
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Suggested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1194,7 +1194,7 @@ static int io_subchannel_chp_event(struc
 			else
 				path_event[chpid] = PE_NONE;
 		}
-		if (cdev)
+		if (cdev && cdev->drv && cdev->drv->path_event)
 			cdev->drv->path_event(cdev, path_event);
 		break;
 	}


