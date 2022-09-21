Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D28D5BF1D3
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 02:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiIUAOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 20:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIUAOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 20:14:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6899E642E8
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 17:14:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34577a9799dso37440947b3.6
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 17:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=C+ZYABhW8irSe+JNLIucyH8M5shk8FJfuzJpu7D+GKs=;
        b=bXSSOUAgOJOUDPnnd3UfIPbllyjUoh3MxyaMpmXFK6HEoCdoFXgyYTCm5qQiI+kVav
         NSmrQ9CX/aArVciww94CGjJ4FHw1yIcCZbrl5UspTxhdugH4VPUDyboerwtSMS85Yejj
         +1AAQ0JnHmidgXSxajWzkcRMUX06Li6ivF+DJQln3YTaBtx8BURIEBEfyKy3O11NgJmg
         G+R418FxXahE/VgIR6rymLZ6IBZB0IJsW5HQLjrAJPKtx5q7NBr6u2BcYWTZqiob9I3g
         gy+8WFx42i9Ba0OJAuz0veqXLbVZwbxi/hgByLk+W2ag1xEnQ7PqJh7BPs/LSnmtUQxd
         Qo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=C+ZYABhW8irSe+JNLIucyH8M5shk8FJfuzJpu7D+GKs=;
        b=JW4ulgVEtRNdWxw7eZmgLwSJcXbndwAtSiImGoV1UP7SIsuxhI5EXoluAvJaAP6zTX
         UaygWK+pET1Pc9Ip7r0IlixN5H8fGQSAxX53E1311betjnO+SEWAF5QJq1ArAv0CbIxf
         gWzq+vi4rwcyelsaekN/OGRAnafgGmM44R0egnyDUFjEWr6QUtHL3IOzg8jOGuH/Dybc
         4sm8PtPp4naApMoXwO0npYRa7IbRWbMUdiAztfFFW3bOQfvOo1qgWRbFSr9tkc+ZObbF
         oNfxGtTekpKIOovLISfjPVz8bFvIwTG4ILArASjQmCpYsci1+wBsSvwRhOSL9OVUxOPL
         YrMw==
X-Gm-Message-State: ACrzQf3WPSl14iM7XfCZbBCsUK/YLVDEuFFaFi6ROUbe28H/JCcUYCOf
        0eDv67D/sFo32uE+M7dulbg9hkebcZ8iJIpWgpXxEg==
X-Google-Smtp-Source: AMsMyM6pBWAhW1xBV9MOZaS8ThYhccCtsVJZksrfg8dbTrwhC3txlAOi8C6z9ALnKts08RWsmcSCnrUSwh3Pu6z1roScOA==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:c6d4:8998:edf3:9779])
 (user=isaacmanjarres job=sendgmr) by 2002:a0d:f741:0:b0:34d:134a:f41d with
 SMTP id h62-20020a0df741000000b0034d134af41dmr9111702ywf.404.1663719257689;
 Tue, 20 Sep 2022 17:14:17 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:14:13 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921001414.4046492-1-isaacmanjarres@google.com>
Subject: [PATCH v1] driver core: Fix bus_type.match() error handling in __driver_attach()
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a driver registers with a bus, it will attempt to match with every
device on the bus through the __driver_attach() function. Currently, if
the bus_type.match() function encounters an error that is not
-EPROBE_DEFER, __driver_attach() will return a negative error code, which
causes the driver registration logic to stop trying to match with the
remaining devices on the bus.

This behavior is not correct; a failure while matching a driver to a
device does not mean that the driver won't be able to match and bind
with other devices on the bus. Update the logic in __driver_attach()
to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 drivers/base/dd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

This problem was not reported anywhere, but rather it was something that
I noticed while looking at this function.

--Isaac

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index ec69b43f926a..6669daf1f31f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1162,7 +1162,11 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
-		return ret;
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (driver_allows_async_probing(drv)) {
-- 
2.37.3.968.ga6b4b080e4-goog

