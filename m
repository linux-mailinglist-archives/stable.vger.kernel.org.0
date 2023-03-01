Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D176A732A
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCASNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjCASNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:13:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775E17EC2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCEA61386
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED49CC433D2;
        Wed,  1 Mar 2023 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694397;
        bh=3dCL7ZJOeQJ7xw/MqvIDsVdkhUDA3CnB3krrQDEF1Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAgiuwNqdtKE6WV+ECZqdyaCHkf5bO1NcPHCpz1JSpaIlyEmvxQm1wOd8kdzUIVwi
         6hLXCI10aahlSGsK0ToEp+heeNd1dVx/4sDZKsKDdAn9OQ9gvyjm/pYIrwNpRrcgvK
         DGxS252nVKy86ZhYumreOJRY/cKZrL4JsxujXAt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Rajaram Regupathy <rajaram.regupathy@intel.com>,
        Saranya Gopal <saranya.gopal@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 34/42] usb: typec: pd: Remove usb_suspend_supported sysfs from sink PDO
Date:   Wed,  1 Mar 2023 19:08:55 +0100
Message-Id: <20230301180658.585091015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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

From: Saranya Gopal <saranya.gopal@intel.com>

commit e4e7b2dc27c4bb877d850eaff69d41410b2f4237 upstream.

As per USB PD specification, 28th bit of fixed supply sink PDO
represents "higher capability" attribute and not "usb suspend
supported" attribute. So, this patch removes the usb_suspend_supported
attribute from sink PDO.

Fixes: 662a60102c12 ("usb: typec: Separate USB Power Delivery from USB Type-C")
Cc: stable <stable@kernel.org>
Reported-by: Rajaram Regupathy <rajaram.regupathy@intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230214114543.205103-1-saranya.gopal@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/pd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/typec/pd.c b/drivers/usb/typec/pd.c
index dc72005d68db..b5ab26422c34 100644
--- a/drivers/usb/typec/pd.c
+++ b/drivers/usb/typec/pd.c
@@ -161,7 +161,6 @@ static struct device_type source_fixed_supply_type = {
 
 static struct attribute *sink_fixed_supply_attrs[] = {
 	&dev_attr_dual_role_power.attr,
-	&dev_attr_usb_suspend_supported.attr,
 	&dev_attr_unconstrained_power.attr,
 	&dev_attr_usb_communication_capable.attr,
 	&dev_attr_dual_role_data.attr,
-- 
2.39.2



