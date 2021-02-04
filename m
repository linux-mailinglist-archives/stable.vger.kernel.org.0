Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3CF310116
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 00:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhBDXw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 18:52:59 -0500
Received: from mout.gmx.net ([212.227.15.15]:58187 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhBDXw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 18:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612482672;
        bh=3ITnrUmgpoREt7A8+/KZYb1DEC4DF6i6j7F4yydeo6c=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jp6Dw9g8Zsbp6o5/S88Cy4nDr9rDr1xQZDWZsXZ2Vv4cl+oQD82h95367s4EdDshS
         69lp7Dz97brz7C0MKIKRsnItmuBYvofJdPECfgzyyYXxmRd0sqvfX/TJ53p5V4crM/
         qHy1ad1kxNlya5AvBsES49naTOJ49VRTM0Vz+JCY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([78.42.220.31]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MKKUv-1lN0Ge3aFr-00Lkpm; Fri, 05
 Feb 2021 00:51:11 +0100
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     peterhuewe@gmx.de, jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        LinoSanfilippo@gmx.de, Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is still valid
Date:   Fri,  5 Feb 2021 00:50:43 +0100
Message-Id: <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:RswaLHu/9erJ2Tp2QWvHm/a/KaCjM6zsK2OLBsiQZEGxLHQB0Kt
 uChSLi++YeHcSQrWm437t2QIZlE2df2VOC6HCk9poPFrh+iHcQ4q44sCEbQuNMMAgp1n7Tt
 eLwxt2m1F6vOaMb0phPeIdjOaMomWMxPkAzxNPg8lKpzXMLNsAZUgWYsEWGuUTsMZxgNKXd
 IHy6j/xG8S5igk9Cvsq4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gUxVhZFlBIU=:WcwaAZcnoISX6uLZt4csmp
 9p4M2k5DHTWo1qqYKFCH46h6bQrUMvflplAdqWDIi2YlPmSPaA/0Me7QKS5RFbkPlf9m+uk7X
 YgHNxUQkCFT/chgTPgGOLboYj2bSELke86NuPQRXiy65i/LW4Z6L69DLRHVHdCEiDld6z+xaR
 9DSfBYwkCMeNI/XzPrsCUoKx+3745l520PIcaTb0D5pBqur4DN8hjClOieCgeLO6KyEisp3cQ
 NcZTMdSfFOxYBrC+PzlBcmoUiidrkSthLzlrm1w7QZqQAVrSffSgO/MvPF7K8SiBYTTmQW3s/
 RcLlilZJeu7o6T47wmu87jCezi2AFzQ0e1Z2rKnIt3TiP3zbcS3IJ8QB8B9wL+nMF6KalFyPJ
 vK4a87+Vi7XawGi3Fu4G5855k+F77l4a6NXV3c/2BLyDV8a0+pt6xu8Zc2kzURTcqAwrdQ578
 IQOEzjhdci61cEHMFJgL3ecx+e7ZO12Mr+QRXyoUAtzK+8eunVbV/a+8ALyucA5CPtfSP+cRK
 3WF/+kiCW3OsL+jgYhWo2aPDGemcCI59DlxO5xjJohSs/kwbRBEvgQXuDyWbVAHQzZiTZqgZ6
 twf/X50L4W25oSbBNXifzEtwlXerBq2WJE+DBMOOtTOrfcRl2nQBpJU3BnVcZQXWb8SQ4kdPF
 GMheG/wdtMX7ROjJMguV1Lu+MpaPSfse0/ldftNXW453jdSSpDmO0M0ID4u24O6qtNNBSOuGs
 RlB5x3yoDxk9m/c+GAk6WeVcOJPPzHL07Ueasnoa658uXzTHLoJ+ci1w4yOr0HtLEmcK7B3uP
 KPTAkDhCsPY2wR9lNCO7aSD4WkjCouXJx/hIh7l3lqkTBwP6PdLB/ODhRGS62dmUFAuqR4eVC
 MqF6bFb8sMichW8pjcNw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTGlubyBTYW5maWxpcHBvIDxsLnNhbmZpbGlwcG9Aa3VuYnVzLmNvbT4KCkluIHRwbTJf
ZGVsX3NwYWNlKCkgY2hpcC0+b3BzIGlzIHVzZWQgZm9yIGZsdXNoaW5nIHRoZSBzZXNzaW9ucy4g
SG93ZXZlcgp0aGlzIGZ1bmN0aW9uIG1heSBiZSBjYWxsZWQgYWZ0ZXIgdHBtX2NoaXBfdW5yZWdp
c3RlcigpIHdoaWNoIHNldHMKdGhlIGNoaXAtPm9wcyBwb2ludGVyIHRvIE5VTEwuCkF2b2lkIGEg
cG9zc2libGUgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGJ5IGNoZWNraW5nIGlmIGNoaXAtPm9w
cyBpcyBzdGlsbAp2YWxpZCBiZWZvcmUgYWNjZXNzaW5nIGl0LgoKRml4ZXM6IGEzZmJmYWU4MmI0
YyAoInRwbTogdGFrZSBUUE0gY2hpcCBwb3dlciBnYXRpbmcgb3V0IG9mIHRwbV90cmFuc21pdCgp
IikKU2lnbmVkLW9mZi1ieTogTGlubyBTYW5maWxpcHBvIDxsLnNhbmZpbGlwcG9Aa3VuYnVzLmNv
bT4KLS0tCiBkcml2ZXJzL2NoYXIvdHBtL3RwbTItc3BhY2UuYyB8IDE1ICsrKysrKysrKystLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jaGFyL3RwbS90cG0yLXNwYWNlLmMgYi9kcml2ZXJzL2NoYXIvdHBt
L3RwbTItc3BhY2UuYwppbmRleCA3ODRiOGIzLi45YTI5YTQwIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2NoYXIvdHBtL3RwbTItc3BhY2UuYworKysgYi9kcml2ZXJzL2NoYXIvdHBtL3RwbTItc3BhY2Uu
YwpAQCAtNTgsMTIgKzU4LDE3IEBAIGludCB0cG0yX2luaXRfc3BhY2Uoc3RydWN0IHRwbV9zcGFj
ZSAqc3BhY2UsIHVuc2lnbmVkIGludCBidWZfc2l6ZSkKIAogdm9pZCB0cG0yX2RlbF9zcGFjZShz
dHJ1Y3QgdHBtX2NoaXAgKmNoaXAsIHN0cnVjdCB0cG1fc3BhY2UgKnNwYWNlKQogewotCW11dGV4
X2xvY2soJmNoaXAtPnRwbV9tdXRleCk7Ci0JaWYgKCF0cG1fY2hpcF9zdGFydChjaGlwKSkgewot
CQl0cG0yX2ZsdXNoX3Nlc3Npb25zKGNoaXAsIHNwYWNlKTsKLQkJdHBtX2NoaXBfc3RvcChjaGlw
KTsKKwlkb3duX3JlYWQoJmNoaXAtPm9wc19zZW0pOworCWlmIChjaGlwLT5vcHMpIHsKKwkJbXV0
ZXhfbG9jaygmY2hpcC0+dHBtX211dGV4KTsKKwkJaWYgKCF0cG1fY2hpcF9zdGFydChjaGlwKSkg
eworCQkJdHBtMl9mbHVzaF9zZXNzaW9ucyhjaGlwLCBzcGFjZSk7CisJCQl0cG1fY2hpcF9zdG9w
KGNoaXApOworCQl9CisJCW11dGV4X3VubG9jaygmY2hpcC0+dHBtX211dGV4KTsKIAl9Ci0JbXV0
ZXhfdW5sb2NrKCZjaGlwLT50cG1fbXV0ZXgpOworCXVwX3JlYWQoJmNoaXAtPm9wc19zZW0pOwor
CiAJa2ZyZWUoc3BhY2UtPmNvbnRleHRfYnVmKTsKIAlrZnJlZShzcGFjZS0+c2Vzc2lvbl9idWYp
OwogfQotLSAKMi43LjQKCg==
