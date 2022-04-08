Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D24FA027
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 01:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiDHXiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 19:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiDHXiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 19:38:13 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53CAC6B4E;
        Fri,  8 Apr 2022 16:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649460959;
        bh=PE93BArNOfspKWatWSSijWYxkhAMOPY4ZFX7FNX7uHQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=DVOU7uZJ0aWbIf5Fdt57sirk94Etp+kJguemPm2oQJnkiKn/VHl2zI/F9zSXe9/jX
         w/WXaVwglLyCAaA6DqNdoGLqN5YQLP65MqT/C5W1zkM6KIrDRUAzHliNRpVewyjY+7
         L2mZVKdts8qS8If7E/6aLPczbwL18wbWLvt41o8w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([46.223.2.213]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MdebB-1oCIxi15hB-00ZcVv; Sat, 09
 Apr 2022 01:35:59 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux@armlinux.org.uk, jirislaby@kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, lukas@wunner.de,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, stable@vger.kernel.org
Subject: [PATCH] serial: amba-pl011: do not time out prematurely when draining tx fifo
Date:   Sat,  9 Apr 2022 01:35:02 +0200
Message-Id: <20220408233503.7251-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:2Pi391PVpa6mz3HDqrEJVvoWX3RP/HWxrw14lQr48Wx7DltIAtf
 8FWeQrDo3ShvEexNvnNKwtwOrEBi8gnsakCStv2bg1751YJF/pJRO+1WCdm1aIRMWYNAOcI
 4MqcCvYZHrIKZWYP0tAyQnBDHwTPv0KwBOajHxojwOiBbNn1woVMA2Hz+RPvSBMBX53tzEY
 rUtDV0HYRY7e9zGN9mPYA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1WIr7NdhmBo=:qrqZHMQgybDqyVMSBON3kN
 S0woaUywjvcNPEqa9b9/3SuSNqJgJku17bjnEdvGX2gFeyGshXwCzf2w3XjyKtdBuaJHVSPpw
 j9HTm2UtR0qqriWGJ96W5j2NKXdSa3p+6R9W4o98okDPGs4npj5JKbJGTQ0k3Etf50r5IeueL
 ADcZIgnissMobyr8nQgfOF+JdPJesYS7ZhUFPQKbH2d59fkYrhzlrOmJ81pSDat7KgIEF5Ueq
 V1/DXS8HSf7nlNv6tN9azg6sSuGKOSlE41X47gyHt7tv+gby5xuSfGtU5HMglEy6h/qpDAXu/
 rWqreuoLq1OB6Zz3y4MDe/LUK6a9n58T8zjmR+lO5D/DWvslM02bvkkD84nvZPsJVaktTn+fV
 SlBlBbMTzlA/kWH2u3mV6Zz/wkzfOjQsvATdeJn1hmNLSetksJvaKMw6ASL2FD0qBfVP/J5XU
 2f9HdCPE4ik8KXhIAMqq20K/OjBv+AVUA3G+8EpFGsWPYQmYQonK+HNzL6r958k6MMpavt++A
 Ygn3LXN8ir3OcqQdR9Nn4FACi4wcbabctA/GDQRvH4KQEu0L5uEllZP0+3LxMtL+fIJL2Ql1O
 AJQJQ2rx3dB81I1sdrECC1Sa4n+RyUVwG7MIcb6n2E3BhhbTfVAXWBXub2/+E90ENqk1vvSzZ
 OBrWHB0wscwp51HR8wGPB3hKznZcxcisj2vzbxus/cm1zvSImc4NGJAtUY5ie//0KIqgPIrx6
 qvch+791bduXYUxRt1IsfmA5tZriDO+BjgNOzemegPnNlvcvLwtVm3z9jlyr0+D+KrjSotgS4
 kpLIOP9JRFwDaYCCnMm6yRqoNzt4oq0gTOAOQBjI6V9CsS7Z5H/9CKvoYO2cWRWbICi0Dwkyu
 wYF6unvYD4i2mSGavB+2wZm6LpSBEe6B1FhxSblTowCyuoBTj1f5j9bkhwShw5bfLIgMvnsZU
 Owf6d5tpXClOiwgmDSRl6viFMttoYcLbkffFsayHtrh4f9vng7vPTJ+Rgsi+m8rLqF3NW9OEQ
 2HVHWEO+PzkQGt17QvxXUwbQtAK2k8VgN/LJKMU9SDCUQB9gN4SLIgmkk5ltT+EYlrIENg4AM
 MSoONKNBbSiWRE=
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,MIME_BASE64_TEXT,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIGN1cnJlbnQgdGltZW91dCBmb3IgZHJhaW5pbmcgdGhlIHR4IGZpZm8gaW4gUlM0ODUgbW9k
ZSBpcyBjYWxjdWxhdGVkIGJ5Cm11bHRpcGx5aW5nIHRoZSB0aW1lIGl0IHRha2VzIHRvIHRyYW5z
bWl0IG9uZSBjaGFyYWN0ZXIgKHdpdGggdGhlIGdpdmVuCmJhdWQgcmF0ZSkgd2l0aCB0aGUgbWF4
aW1hbCBudW1iZXIgb2YgY2hhcmFjdGVycyBpbiB0aGUgdHggcXVldWUuCgpUaGlzIHRpbWVvdXQg
aXMgdG9vIHNob3J0IGZvciB0d28gcmVhc29uczoKRmlyc3Qgd2hlbiBjYWxjdWxhdGluZyB0aGUg
dGltZSB0byB0cmFuc21pdCBvbmUgY2hhcmFjdGVyIGludGVnZXIgZGl2aXNpb24KaXMgdXNlZCB3
aGljaCBtYXkgcm91bmQgZG93biB0aGUgcmVzdWx0IGluIGNhc2Ugb2YgYSByZW1haW5kZXIgb2Yg
dGhlCmRpdmlzaW9uLgoKRml4IHRoaXMgYnkgcm91bmRpbmcgdXAgdGhlIGRpdmlzaW9uIHJlc3Vs
dC4KClNlY29uZCB0aGUgaGFyZHdhcmUgbWF5IG5lZWQgYWRkaXRpb25hbCB0aW1lIChlLmcgZm9y
IGZpcnN0IHB1dHRpbmcgdGhlCmNoYXJhY3RlcnMgZnJvbSB0aGUgZmlmbyBpbnRvIHRoZSBzaGlm
dCByZWdpc3RlcikgYmVmb3JlIHRoZSBjaGFyYWN0ZXJzIGFyZQphY3R1YWxseSBwdXQgb250byB0
aGUgd2lyZS4KClRvIGJlIG9uIHRoZSBzYWZlIHNpZGUgZG91YmxlIHRoZSBjdXJyZW50IG1heGlt
dW0gbnVtYmVyIG9mIGl0ZXJhdGlvbnMKdGhhdCBhcmUgdXNlZCB0byB3YWl0IGZvciB0aGUgcXVl
dWUgZHJhaW5pbmcuCgpGaXhlczogOGQ0NzkyMzc3MjdjICgic2VyaWFsOiBhbWJhLXBsMDExOiBh
ZGQgUlM0ODUgc3VwcG9ydCIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYt
Ynk6IExpbm8gU2FuZmlsaXBwbyA8TGlub1NhbmZpbGlwcG9AZ214LmRlPgotLS0KIGRyaXZlcnMv
dHR5L3NlcmlhbC9hbWJhLXBsMDExLmMgfCA5ICsrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDcg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3R0eS9z
ZXJpYWwvYW1iYS1wbDAxMS5jIGIvZHJpdmVycy90dHkvc2VyaWFsL2FtYmEtcGwwMTEuYwppbmRl
eCA1MWVjYjA1MGFlNDAuLjRkMTFhM2U1NDdmOSAxMDA2NDQKLS0tIGEvZHJpdmVycy90dHkvc2Vy
aWFsL2FtYmEtcGwwMTEuYworKysgYi9kcml2ZXJzL3R0eS9zZXJpYWwvYW1iYS1wbDAxMS5jCkBA
IC0xMjU1LDEzICsxMjU1LDE4IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBwbDAxMV9kbWFfcnhfcnVu
bmluZyhzdHJ1Y3QgdWFydF9hbWJhX3BvcnQgKnVhcCkKIAogc3RhdGljIHZvaWQgcGwwMTFfcnM0
ODVfdHhfc3RvcChzdHJ1Y3QgdWFydF9hbWJhX3BvcnQgKnVhcCkKIHsKKwkvKgorCSAqIFRvIGJl
IG9uIHRoZSBzYWZlIHNpZGUgb25seSB0aW1lIG91dCBhZnRlciB0d2ljZSBhcyBtYW55IGl0ZXJh
dGlvbnMKKwkgKiBhcyBmaWZvIHNpemUuCisJICovCisJY29uc3QgaW50IE1BWF9UWF9EUkFJTl9J
VEVSUyA9IHVhcC0+cG9ydC5maWZvc2l6ZSAqIDI7CiAJc3RydWN0IHVhcnRfcG9ydCAqcG9ydCA9
ICZ1YXAtPnBvcnQ7CiAJaW50IGkgPSAwOwogCXUzMiBjcjsKIAogCS8qIFdhaXQgdW50aWwgaGFy
ZHdhcmUgdHggcXVldWUgaXMgZW1wdHkgKi8KIAl3aGlsZSAoIXBsMDExX3R4X2VtcHR5KHBvcnQp
KSB7Ci0JCWlmIChpID09IHBvcnQtPmZpZm9zaXplKSB7CisJCWlmIChpID4gTUFYX1RYX0RSQUlO
X0lURVJTKSB7CiAJCQlkZXZfd2Fybihwb3J0LT5kZXYsCiAJCQkJICJ0aW1lb3V0IHdoaWxlIGRy
YWluaW5nIGhhcmR3YXJlIHR4IHF1ZXVlXG4iKTsKIAkJCWJyZWFrOwpAQCAtMjA1Miw3ICsyMDU3
LDcgQEAgcGwwMTFfc2V0X3Rlcm1pb3Moc3RydWN0IHVhcnRfcG9ydCAqcG9ydCwgc3RydWN0IGt0
ZXJtaW9zICp0ZXJtaW9zLAogCSAqIHdpdGggdGhlIGdpdmVuIGJhdWQgcmF0ZS4gV2UgdXNlIHRo
aXMgYXMgdGhlIHBvbGwgaW50ZXJ2YWwgd2hlbiB3ZQogCSAqIHdhaXQgZm9yIHRoZSB0eCBxdWV1
ZSB0byBlbXB0eS4KIAkgKi8KLQl1YXAtPnJzNDg1X3R4X2RyYWluX2ludGVydmFsID0gKGJpdHMg
KiAxMDAwICogMTAwMCkgLyBiYXVkOworCXVhcC0+cnM0ODVfdHhfZHJhaW5faW50ZXJ2YWwgPSBE
SVZfUk9VTkRfVVAoYml0cyAqIDEwMDAgKiAxMDAwLCBiYXVkKTsKIAogCXBsMDExX3NldHVwX3N0
YXR1c19tYXNrcyhwb3J0LCB0ZXJtaW9zKTsKIAoKYmFzZS1jb21taXQ6IDFhM2IxYmJhN2M3YTVl
YjhhMTE1MTNjZjg4NDI3Y2I5ZDc3YmM2MGEKLS0gCjIuMzUuMQoK
