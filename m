Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D631579D48
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbiGSMuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241777AbiGSMss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628998E1D0;
        Tue, 19 Jul 2022 05:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C94617D6;
        Tue, 19 Jul 2022 12:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70778C341C6;
        Tue, 19 Jul 2022 12:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233139;
        bh=rcwtNqc+GPYqJXpwkFe1nLuwgUVQoC9tmju2aIdG9LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhyJgwm28rt8AJKVoubWNXPYSdKiwMB1uGI6o1Fg4b2ueFMcWh8UCb2sNXt8oOI8J
         d1VpBLwdtMyrc//H7LEXEyYeEVvzpTQEWc/SGAdhNfCCv3lu7TWOwuazliUJcho5Nl
         BE7LjOxXRnfC49yYFa6aTjRFNAVxGW/9tfQKeAmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.18 002/231] usb: typec: add missing uevent when partner support PD
Date:   Tue, 19 Jul 2022 13:51:27 +0200
Message-Id: <20220719114714.426482805@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <quic_linyyuan@quicinc.com>

commit 6fb9e1d94789e8ee5a258a23bc588693f743fd6c upstream.

System like Android allow user control power role from UI, it is possible
to implement application base on typec uevent to refresh UI, but found
there is chance that UI show different state from typec attribute file.

In typec_set_pwr_opmode(), when partner support PD, there is no uevent
send to user space which cause the problem.

Fix it by sending uevent notification when change power mode to PD.

Fixes: bdecb33af34f ("usb: typec: API for controlling USB Type-C Multiplexers")
Cc: stable@vger.kernel.org
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1656662934-10226-1-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1718,6 +1718,7 @@ void typec_set_pwr_opmode(struct typec_p
 			partner->usb_pd = 1;
 			sysfs_notify(&partner_dev->kobj, NULL,
 				     "supports_usb_power_delivery");
+			kobject_uevent(&partner_dev->kobj, KOBJ_CHANGE);
 		}
 		put_device(partner_dev);
 	}


