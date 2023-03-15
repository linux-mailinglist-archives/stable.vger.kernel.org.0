Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419306BB143
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjCOM0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjCOMZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B0F99C13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC84461D40
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AD0C433EF;
        Wed, 15 Mar 2023 12:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883098;
        bh=pY5oKRL/60m1hFyGM31zA6AIXDpuAGgqf/QG1Ny+1ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdscGdk2wio/ibULY0Yd8i3GUdd6YPu8X/38/X+R7MgZrgnvdmPZeC2uqGMa9AjKI
         4bfoQteXYAY/fwYPZCcTtpM9rnNXsk9BNKMcKaVpCysuwaXF83zbCVJIvmti6UrSVw
         G9lyS+E8FAniOSP7d3W8nig+2oJk/EZCuxLIl/xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 015/145] nfc: change order inside nfc_se_io error path
Date:   Wed, 15 Mar 2023 13:11:21 +0100
Message-Id: <20230315115739.497451209@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 7d834b4d1ab66c48e8c0810fdeadaabb80fa2c81 upstream.

cb_context should be freed on the error path in nfc_se_io as stated by
commit 25ff6f8a5a3b ("nfc: fix memory leak of se_io context in
nfc_genl_se_io").

Make the error path in nfc_se_io unwind everything in reverse order, i.e.
free the cb_context after unlocking the device.

Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230306212650.230322-1-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1446,8 +1446,8 @@ static int nfc_se_io(struct nfc_dev *dev
 	return rc;
 
 error:
-	kfree(cb_context);
 	device_unlock(&dev->dev);
+	kfree(cb_context);
 	return rc;
 }
 


