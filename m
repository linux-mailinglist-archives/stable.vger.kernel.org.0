Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C59D59D659
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243295AbiHWI12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243657AbiHWIZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9938B6B169;
        Tue, 23 Aug 2022 01:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21970B81C29;
        Tue, 23 Aug 2022 08:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743D4C433D7;
        Tue, 23 Aug 2022 08:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242419;
        bh=ckMBl119NctqlvjDKtx+0nKMG/fB7D6nQeW4nRBcDOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3K3MAOmN/waxmPQAkaoTmVrLU8wyxZokPXSY2qA9sNmHPLfPi3EB/1s2kxMUuDOk
         yAIpM6oGwrSXrTbB+9QwhwNAu9Ib1G8z7BdHpekaDkelpXXbIyUm+UId+S5JnXPRCw
         VBam0vf58qKDKdqC5AU0csvNxQNDM9QHr6ozZBwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 112/365] dt-bindings: input: iqs7222: Extend slider-mapped GPIO to IQS7222C
Date:   Tue, 23 Aug 2022 10:00:13 +0200
Message-Id: <20220823080122.897868947@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

commit f0ea452715d72bc365d2b401ceb458f5ae82eeec upstream.

Although the IQS7222C does not offer slider gesture support, the
press/release event can still be mapped to any of the IQS7222C's
three GPIO pins. Update the binding to reflect this relationship.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-10-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/input/azoteq,iqs7222.yaml        | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index c9c3a1e9bcae..32d0d5190334 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -611,16 +611,15 @@ patternProperties:
           azoteq,gpio-select:
             $ref: /schemas/types.yaml#/definitions/uint32-array
             minItems: 1
-            maxItems: 1
+            maxItems: 3
             items:
               minimum: 0
-              maximum: 0
+              maximum: 2
             description: |
-              Specifies an individual GPIO mapped to a tap, swipe or flick
-              gesture as follows:
+              Specifies one or more GPIO mapped to the event as follows:
               0: GPIO0
-              1: GPIO3 (reserved)
-              2: GPIO4 (reserved)
+              1: GPIO3 (IQS7222C only)
+              2: GPIO4 (IQS7222C only)
 
               Note that although multiple events can be mapped to a single
               GPIO, they must all be of the same type (proximity, touch or
@@ -705,6 +704,14 @@ allOf:
               multipleOf: 4
               maximum: 1020
 
+          patternProperties:
+            "^event-(press|tap|(swipe|flick)-(pos|neg))$":
+              properties:
+                azoteq,gpio-select:
+                  maxItems: 1
+                  items:
+                    maximum: 0
+
     else:
       patternProperties:
         "^channel-([0-9]|1[0-9])$":
@@ -721,8 +728,6 @@ allOf:
 
                 azoteq,gesture-dist: false
 
-                azoteq,gpio-select: false
-
 required:
   - compatible
   - reg
-- 
2.37.2



