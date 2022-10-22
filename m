Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC215608A53
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiJVIum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbiJVItz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852F1277A1D;
        Sat, 22 Oct 2022 01:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82C9CB82E40;
        Sat, 22 Oct 2022 08:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF05EC433C1;
        Sat, 22 Oct 2022 08:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426084;
        bh=30oaRr/+0z675hWSv80pGu8HA4e+AOyozO+DFfi9qj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U880E7BfUUzLXmJsSAaaopKJqy3ZJfwYqIQdmf6VuXQ89FyPHteK/vFWURkP+aj03
         ji/DZpFSbl1IPPke7jgEFZ9PdK/O6YKeog75CS5UE6HaHe0BkoK00s7cXzFyxy2rbT
         4CHMg4jItEtvUd5j1DE6O+vX5jRncO5mZNpiOMmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 713/717] HID: uclogic: Add missing suffix for digitalizers
Date:   Sat, 22 Oct 2022 09:29:52 +0200
Message-Id: <20221022072530.001085316@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

commit 0977fda0587cbc5403651ba169e264aa01e8a026 upstream.

The Pen (0x02) application usage was changed to Digitalizer (0x01) in
commit f7d8e387d9ae ("HID: uclogic: Switch to Digitizer usage for
styluses"). However, a suffix was not selected for the new usage.

Handle the digitalizer application usage in uclogic_input_configured()
and add the required suffix.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
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


