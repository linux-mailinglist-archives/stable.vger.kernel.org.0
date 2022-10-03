Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF375F2906
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJCHMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJCHMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:12:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52537193;
        Mon,  3 Oct 2022 00:12:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D398060F9C;
        Mon,  3 Oct 2022 07:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6290C433C1;
        Mon,  3 Oct 2022 07:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781134;
        bh=au0Hli03x+hD2RTJxEq0cDrYZzeJVBLQh548M23Y5B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q07wUe/N+lJUxTHcJo6P/UFvSuUtodDyk93BIuYsBNRYFc099NSlzoAEWSJTG8S7f
         wv7NM/qRgSeP/Oc0Ye9r65L27ei4typHclNlwDP2sKnBgvc/4kGUyEAS0aLDvF0q0O
         PD2BkaMTP4b5YuIAt2vMBqoKP2akD3gHvsup3q/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.19 010/101] usb: typec: ucsi: Remove incorrect warning
Date:   Mon,  3 Oct 2022 09:10:06 +0200
Message-Id: <20221003070724.762495136@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 415ba26cb73f7d22a892043301b91b57ae54db02 upstream.

Sink only devices do not have any source capabilities, so
the driver should not warn about that. Also DRP (Dual Role
Power) capable devices, such as USB Type-C docking stations,
do not return any source capabilities unless they are
plugged to a power supply themselves.

Fixes: 1f4642b72be7 ("usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220922145924.80667-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -588,8 +588,6 @@ static int ucsi_get_pdos(struct ucsi_con
 				num_pdos * sizeof(u32));
 	if (ret < 0 && ret != -ETIMEDOUT)
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
-	if (ret == 0 && offset == 0)
-		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
 
 	return ret;
 }


