Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF684D8343
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbiCNMMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241913AbiCNMJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BAC21E1A;
        Mon, 14 Mar 2022 05:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB917B80DED;
        Mon, 14 Mar 2022 12:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BAFC340E9;
        Mon, 14 Mar 2022 12:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259571;
        bh=FqpALfqcNa6EdMdvrr0CBCpp7kSW2XO976p/OpdCGBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjEsZG8pdm+WBn7UqtfRXVRLMAAT/XWjpCiJnTHObrjBS7MZW6Dtt3kOqT3CaMZJW
         MRw7SaIxPqrSySPhOFjG+r1E96h6NdISv+2eTyrZvueb+QCX/d3PvBePfhXfvS7ni3
         Da18mQ8gfCjtLCXITDB1pA9VT9Uujdn0X9WVL6vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/110] HID: vivaldi: fix sysfs attributes leak
Date:   Mon, 14 Mar 2022 12:53:10 +0100
Message-Id: <20220314112743.265392306@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit cc71d37fd1f11e0495b1cf580909ebea37eaa886 ]

The driver creates the top row map sysfs attribute in input_configured()
method; unfortunately we do not have a callback that is executed when HID
interface is unbound, thus we are leaking these sysfs attributes, for
example when device is disconnected.

To fix it let's switch to managed version of adding sysfs attributes which
will ensure that they are destroyed when the driver is unbound.

Fixes: 14c9c014babe ("HID: add vivaldi HID driver")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-vivaldi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-vivaldi.c b/drivers/hid/hid-vivaldi.c
index 576518e704ee..d57ec1767037 100644
--- a/drivers/hid/hid-vivaldi.c
+++ b/drivers/hid/hid-vivaldi.c
@@ -143,7 +143,7 @@ static void vivaldi_feature_mapping(struct hid_device *hdev,
 static int vivaldi_input_configured(struct hid_device *hdev,
 				    struct hid_input *hidinput)
 {
-	return sysfs_create_group(&hdev->dev.kobj, &input_attribute_group);
+	return devm_device_add_group(&hdev->dev, &input_attribute_group);
 }
 
 static const struct hid_device_id vivaldi_table[] = {
-- 
2.34.1



