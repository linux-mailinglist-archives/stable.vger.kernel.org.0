Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B02851A782
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355143AbiEDRFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355201AbiEDREM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF014E3B8;
        Wed,  4 May 2022 09:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA701B827AB;
        Wed,  4 May 2022 16:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760E2C385A4;
        Wed,  4 May 2022 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683166;
        bh=j9fGvGTJIWWMls+EO3uh4k7EJ/UNIJzX+68+UCC0GGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNdKtSC0SNjgUlQNLdHQRrNY/ThtkecunJKHD+XoIzaiF4RqAhP0C+RaWynAfMgef
         efObYVY2Zr44M52OCn1FyZnxYLXGYESQl/T5lIIGJlsBdhlfIjncWsIgQIzwyepxL8
         HpVvZwmxlMnISjycnht5W+L6cRWBXh6mYT6ws8YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jack Pham <quic_jackp@quicinc.com>
Subject: [PATCH 5.15 018/177] usb: typec: ucsi: Fix reuse of completion structure
Date:   Wed,  4 May 2022 18:43:31 +0200
Message-Id: <20220504153054.996787420@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit e25adcca917d7e4cdc1dc6444d0692ffda7594bf upstream.

The role swapping completion variable is reused, so it needs
to be reinitialised every time. Otherwise it will be marked
as done after the first time it's used and completing
immediately.

Link: https://lore.kernel.org/linux-usb/20220325203959.GA19752@jackp-linux.qualcomm.com/
Fixes: 6df475f804e6 ("usb: typec: ucsi: Start using struct typec_operations")
Cc: stable@vger.kernel.org
Reported-and-suggested-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220405134824.68067-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -955,6 +955,8 @@ static int ucsi_dr_swap(struct typec_por
 	     role == TYPEC_HOST))
 		goto out_unlock;
 
+	reinit_completion(&con->complete);
+
 	command = UCSI_SET_UOR | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_SET_UOR_ROLE(role);
 	command |= UCSI_SET_UOR_ACCEPT_ROLE_SWAPS;
@@ -991,6 +993,8 @@ static int ucsi_pr_swap(struct typec_por
 	if (cur_role == role)
 		goto out_unlock;
 
+	reinit_completion(&con->complete);
+
 	command = UCSI_SET_PDR | UCSI_CONNECTOR_NUMBER(con->num);
 	command |= UCSI_SET_PDR_ROLE(role);
 	command |= UCSI_SET_PDR_ACCEPT_ROLE_SWAPS;


