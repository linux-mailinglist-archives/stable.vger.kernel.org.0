Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A1B6047D6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiJSNqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiJSNpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:45:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D911382E1;
        Wed, 19 Oct 2022 06:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA6EB82399;
        Wed, 19 Oct 2022 09:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B366CC433D6;
        Wed, 19 Oct 2022 09:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170099;
        bh=PrK2p4fymt8fUSfP4C7APe5C2pVVTGHBBgmiexJTfSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3IVwkHpH+7VmMp0kVWmWwCrcziy6tyaiTMQ6aKod5VYlfKt9hbL4LvG4ym83p+t/
         mLe+drfJDH+Mtwj7u0dKHyvnFJ7PwjU+sCgjzLlC5nNelyzqdOxZraEXmAkrc++K9N
         MOm674OJYURydO+UcVUsd96wYVjqYsHT2DBXFGng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 480/862] HID: uclogic: Add missing suffix for digitalizers
Date:   Wed, 19 Oct 2022 10:29:27 +0200
Message-Id: <20221019083311.156155236@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 0977fda0587cbc5403651ba169e264aa01e8a026 ]

The Pen (0x02) application usage was changed to Digitalizer (0x01) in
commit f7d8e387d9ae ("HID: uclogic: Switch to Digitizer usage for
styluses"). However, a suffix was not selected for the new usage.

Handle the digitalizer application usage in uclogic_input_configured()
and add the required suffix.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Fixes: f7d8e387d9ae ("HID: uclogic: Switch to Digitizer usage for styluses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -153,6 +153,7 @@ static int uclogic_input_configured(stru
 			suffix = "Pad";
 			break;
 		case HID_DG_PEN:
+		case HID_DG_DIGITIZER:
 			suffix = "Pen";
 			break;
 		case HID_CP_CONSUMER_CONTROL:


