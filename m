Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD916212AE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiKHNmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbiKHNli (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F5B9586
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC59CB81AA1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13130C433D6;
        Tue,  8 Nov 2022 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914894;
        bh=yDnH0bxV+LTX8E56aXctnL+8ouOlfc9f8pS8W2lDEU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKbMSD3r2aTIyK70/41ZuWrQ9nxenVFuREbnjcrUjmXLsRGPKeOGcm3hIYqo7N7JV
         FHBAMC3TyeiF9s9UmdqSsXux5+f0loKuGpNNvyKu5drx+ydzLlwNmUUE8GWvXZQD7b
         z01WVoEoRgqql2FCpbo/5a/QXj4f9NNSDVpTLYP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Tam=C3=A1s=20Koczka?= <poprdi@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>
Subject: [PATCH 4.9 20/30] Bluetooth: L2CAP: Fix attempting to access uninitialized memory
Date:   Tue,  8 Nov 2022 14:39:08 +0100
Message-Id: <20221108133327.471440252@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b1a2cd50c0357f243b7435a732b4e62ba3157a2e upstream.

On l2cap_parse_conf_req the variable efs is only initialized if
remote_efs has been set.

CVE: CVE-2022-42895
CC: stable@vger.kernel.org
Reported-by: Tamás Koczka <poprdi@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3541,7 +3541,8 @@ done:
 			l2cap_add_conf_opt(&ptr, L2CAP_CONF_RFC,
 					   sizeof(rfc), (unsigned long) &rfc, endptr - ptr);
 
-			if (test_bit(FLAG_EFS_ENABLE, &chan->flags)) {
+			if (remote_efs &&
+			    test_bit(FLAG_EFS_ENABLE, &chan->flags)) {
 				chan->remote_id = efs.id;
 				chan->remote_stype = efs.stype;
 				chan->remote_msdu = le16_to_cpu(efs.msdu);


