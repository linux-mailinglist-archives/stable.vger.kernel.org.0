Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5096314AB
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 15:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKTO2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 09:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKTO2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 09:28:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3A413DE4;
        Sun, 20 Nov 2022 06:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1668954490; bh=FFLjOZn0sVHKOreaEmKwpRdWPja50G8UcNn6gnxIzrY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ncSXXE3CeosOJ1S0V0vpONVMqGIFacon2JAF5mvmrhqfFuDfJkYgEN2H2rDg0dH2B
         wS2X4g2u4e/Fzo8CJ3EDfNi6csfNJJWip/UmTKs9FpxYT+CazJiWjPMIKpq3stQKAG
         oYrgAVoDXeVeCx1r2Spgqu7KGOHlvhNfj5SC0cKtXp/ErF2PAcPPYIwfB8jHV9WSUA
         6xG3M9L7xWd3d3VF53VznP/K+qBTm67WK7grh6vLOQgNhK67e8pFp4oywyvFhGcQ0z
         OrCONTLmWjSYODPGvvQ41bOrc++B3tUp/ygZxkGUjv3YGeEa4uzDOBWRfJrfyfN20E
         5TWTmMC48izbQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from Venus.speedport.ip ([84.162.7.17]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MGQjH-1oigGV2ei5-00Gma9; Sun, 20
 Nov 2022 15:28:10 +0100
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     airlied@gmail.com, daniel@ffwll.ch, eric@anholt.net
Cc:     emma@anholt.net, mripard@kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        l.sanfilippo@kunbus.com, LinoSanfilippo@gmx.de, lukas@wunner.de,
        p.rosenberger@kunbus.com, stable@vger.kernel.org
Subject: [PATCH] drm/vc4: Fix NULL pointer access in vc4_platform_drm_probe()
Date:   Sun, 20 Nov 2022 15:27:37 +0100
Message-Id: <20221120142737.17519-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:qQu1bYLAxugZ7PmynALkLG5dBwB5an5uvZob0l76RManhYz9egy
 i91IPntzWX8eo5d57MDDd0bGH+LZfUEM8O2uaszoDE96RuiKy4EagpjPe5o7A3QvRAnRGw0
 1rcKhaOjxUReLTR+oDvu8DaD0pc1+pSq7blXlZdoiGF+WHtGHrY3W4sn8nXg1PouZpkVZjN
 4j+QyUNXc1t+cNoSiZWkw==
UI-OutboundReport: notjunk:1;M01:P0:MYmmDVCTXIs=;FL4fdtuLC8o8EL6abdYXsfyRxa8
 AT9Xhze3bZaar+LDJTIAKJrqq3u8vXundam1cS8jfFFvbv8iKhGKUHjfptQ+p8BWNqiURW1cg
 NcDVkCB3Y8kYvEdnNJQYpyW5mRc1H+PC4tz6TxHACtJadjMSI315I6EV7Qd6LqWIeTM3VkgN7
 ehA4xbr4l0/CxSV8HTqy/sJCq1aC/2PMnvw3j1zyQYWFX0qhmDdLOxc477lUPjZg3SIWfXOmo
 qnPo/Mv++/x50L325Gu41Xis6OIQWZkXh2xcnzkpnKzHyZzRHWz938khidR3T8RU++/kOg1+i
 vcq2a2hZe4Ns/wAf7JmtA0seFpetshFhwIFVUdelxlYrbZHX2Pdjjt9EPr29IOjw8AQ317vbm
 529uRdNEsxN8cr+tuFfbpg3kkSJuG51oIZl5O4JbvIl6Y3OdYhGi4T/Xq5fo5XNjwDlprNG/x
 M4HVeAGU6A/Bb1eLMIRpJ8WZt41b45cjd4BvC39uB5lWp+Mvvih98MAmA/O1yBgkCoPsb88Yb
 Kxe+DrGzWzcLvGrLLzQgpviBVfP1VNmxsJCUaELzsy1RvllJidHzZdDL8w0Pja5zka+Hu+ccx
 OpkqwotbkKSU83Ht6tL2X9HLCVuZIN9YlN/L8TXwCUnD/ZVJKn7HoqeeTjNj+1mV4ADrNAfgB
 JVs36RWBneGsv5CxLNK2/Ong2Wr1EPrw7hEgyPFLfncCBVwZibggtjNaL4J1Usw9wklYnXdl5
 GyFeFenCXEcX25ryv3jc9/DNF75WCli0ju5KN3J9xLHezCn0ZbtCgEUIl2y6FiGmqYV/URICR
 i5q7/alaOi4COBLMf3O3alWzb8m3UJNo3svmgh1eJqUcpym2HjdMWAg03fK4uj9yBbWaZP/eG
 FEFFrcvqqlGFUvzt4HI1m/43nIrfQmhCqmrn8oALy+OpzJIUH68XnYDXHClTO81RpHDhUN2cP
 k+YJxQ==
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTGlubyBTYW5maWxpcHBvIDxsLnNhbmZpbGlwcG9Aa3VuYnVzLmNvbT4KCkluIHZjNF9w
bGF0Zm9ybV9kcm1fcHJvYmUoKSBmdW5jdGlvbiB2YzRfbWF0Y2hfYWRkX2RyaXZlcnMoKSBpcyBj
YWxsZWQgdG8KZmluZCBjb21wb25lbnQgbWF0Y2hlcyBmb3IgdGhlIGNvbXBvbmVudCBkcml2ZXJz
LiBJZiBubyBzdWNoIG1hdGNoIGlzIGZvdW5kCnRoZSBwYXNzZWQgdmFyaWFibGUgIm1hdGNoIiBp
cyBzdGlsbCBOVUxMIGFmdGVyIHRoZSBmdW5jdGlvbiByZXR1cm5zLgoKRG8gbm90IHBhc3MgIm1h
dGNoIiB0byBjb21wb25lbnRfbWFzdGVyX2FkZF93aXRoX21hdGNoKCkgaW4gdGhpcyBjYXNlIHNp
bmNlCnRoaXMgcmVzdWx0cyBpbiBhIE5VTEwgcG9pbnRlciBhY2Nlc3MgYXMgc29vbiBhcyBtYXRj
aC0+bnVtIGlzIHVzZWQgdG8KYWxsb2NhdGUgYSBjb21wb25lbnRfbWF0Y2ggYXJyYXkuIEluc3Rl
YWQgcmV0dXJuIHdpdGggLUVOT0RFViBmcm9tIHRoZQpkcml2ZXJzIHByb2JlIGZ1bmN0aW9uLgoK
Rml4ZXM6IGM4Yjc1YmNhOTJjYiAoImRybS92YzQ6IEFkZCBLTVMgc3VwcG9ydCBmb3IgUmFzcGJl
cnJ5IFBpLiIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IExpbm8g
U2FuZmlsaXBwbyA8bC5zYW5maWxpcHBvQGt1bmJ1cy5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJt
L3ZjNC92YzRfZHJ2LmMgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS92YzQvdmM0X2Rydi5jIGIvZHJpdmVycy9ncHUv
ZHJtL3ZjNC92YzRfZHJ2LmMKaW5kZXggMjAyNzA2M2ZkYzMwLi4yZTUzZDdmOGFkNDQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS92YzQvdmM0X2Rydi5jCisrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS92YzQvdmM0X2Rydi5jCkBAIC00MzcsNiArNDM3LDkgQEAgc3RhdGljIGludCB2YzRfcGxhdGZv
cm1fZHJtX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJdmM0X21hdGNoX2Fk
ZF9kcml2ZXJzKGRldiwgJm1hdGNoLAogCQkJICAgICAgY29tcG9uZW50X2RyaXZlcnMsIEFSUkFZ
X1NJWkUoY29tcG9uZW50X2RyaXZlcnMpKTsKIAorCWlmICghbWF0Y2gpCisJCXJldHVybiAtRU5P
REVWOworCiAJcmV0dXJuIGNvbXBvbmVudF9tYXN0ZXJfYWRkX3dpdGhfbWF0Y2goZGV2LCAmdmM0
X2RybV9vcHMsIG1hdGNoKTsKIH0KIAoKYmFzZS1jb21taXQ6IDMwYTBiOTViMTMzNWUxMmVmZWY4
OWRkNzg1MThlZDNlNGE3MWE3NjMKLS0gCjIuMzYuMQoK
