Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA526617F5
	for <lists+stable@lfdr.de>; Sun,  8 Jan 2023 19:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjAHSSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 13:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbjAHSSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 13:18:07 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF941DA;
        Sun,  8 Jan 2023 10:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673201876; bh=Ue64tR1L9y9zqhBq+z1LUgoa2umwcYX39u8aBNldhkU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=nsFplF0j940ChYwpMPhXePVg1LaweDnJIMNnDfU9HsB8m19+bh1+EUagej/6KV/vd
         bRCuavSg8gro4GbbRif9SvQ7ateVxCW3NFp8cY66oGIG/4BQmcECrJLCEEAAGgsjNm
         QmaF3APuUeoIxP5wrRr3QZudUlIOMlg0bnlZG8g6+gQ0sLieVddp9rm8+nMEyIMGoe
         ZvIy3nwf0idhL21DY/EUgES6V749Ok4mGjf7zN/S1FOBZuQZQSEa3ahIsIvSuUXgNE
         6LYtMEeLihr6uGpBcDVY6G2JCo/eRhANTTK5WuzpIjurGEyM1ORr+BzUEHZfXmnzGl
         0S8rsz9Uv57cA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from Venus.speedport.ip ([84.162.7.17]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MD9XF-1p5Xpl358r-0099D8; Sun, 08
 Jan 2023 19:17:56 +0100
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     linux@armlinux.org.uk, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, l.sanfilippo@kunbus.com,
        LinoSanfilippo@gmx.de, lukas@wunner.de, p.rosenberger@kunbus.com,
        stable@vger.kernel.org
Subject: [PATCH] serial: amba-pl011: fix high priority character transmission in rs486 mode
Date:   Sun,  8 Jan 2023 19:17:35 +0100
Message-Id: <20230108181735.10937-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:wjqYc8SNEaE4jlrIZG5Osc3vN+ELeRU7LHPoC3iLh6qm4AykcZ9
 +Og6ZfK+ZBqkqoQma8XzayY5F0zgF7ozCrch7/q9NkLZD00c6Wram5zcGqMm+dTze4rH4n2
 hSwSLg1i1l/9CODvtDOjlMXCSUgIxuXzQlmwh9gyL94Ul+1f3aVps+uCqZuR3M52o7k1t4k
 t6dlAGMdTCTm2NL4lbBig==
UI-OutboundReport: notjunk:1;M01:P0:9bzYUfwnTaw=;4W8UX6PCPm3CIzddWsYVLzW937E
 QdBoQVS2ndbg57qNKGmG31AQFVnOR9yN1OFsrz+nXWyaVlD3uZUGMbaqklm/bJBnPCZXr3/nA
 SMwJNN6VFfJbMNpjG5M50DF7r8MrkZedWe5S6/1JvGrUNCY9TgNp2NQDNuIeHzoxXQ3MiISHu
 MxY1TxgqYtitfTNoJd/JiEInSpKfBZECrf9SJI99njtJ9DLytnSbCgx6ib19GjfLW2ZCmhrOa
 hlJq2tn/oOIDj6rR0J4z0sxNH7whv9QEXZOlxosTmC2bkjfup3yUpW3A7sZOuJ2r378RqAmDI
 sp93+jkmEQdEqztATVYVsgfU2NF4Rt1/ATnY2VbTJWWwjX+UXRpQ8jqdotrpvqjvAjRvkUhcG
 eEYIwoyO9ZRR2XJis58AeSxWj5dhGvnK5u4UbJ+qs21tL9x6z9/A133iLR9Myuo0HWc1pK1s8
 HxYs+IVZ6DULM2wUj0L7sKbGYVHqopALdUeAxFXi/e7j1ehJ/T10eUd4uJJOat51bzwY1io4n
 guOZ42UHKkJHnjg4CiIsyD58snsgOttRZz/Aji2C7IZ1/pz1mNuuE+61zD3bhdJIKZ7Ho7gZB
 ogHXf5PoTb34oRI32uSuB6rtnR+ZcFSh6/91R9pRi02fqD4r1Utj4dkkV3u/zsQu0hZ+WJNSx
 NCJ7R5KENqySdQu26m8TQGyaBcAIUjNQ4TugGSsy6UoVJItQV3GUK/G0qS6Ag2Y0WrXRmkbb5
 mOvZSIXrjK8RELMsGQ+u/1jytY0ONPewe3mvF3k9VHBlI1Muo1ozpk3xBvXm5mGdIb9AMXVcd
 cvWCblvZ6SU+P89+qr2qNiwQxN7BaXY8QbKiwK5Zs8KsygWU0i9Fv75KOc6No857FUdL5tJUH
 kILSWkkQ8TgshG8K8QA2qy3Omdx9OK8hNNoeXIUgycsK+y0tidr44aU5PY9ASuP+L4OaR6qbw
 w9TYWthZD8gI6r+E8HPVvaLJ3AI=
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogTGlubyBTYW5maWxpcHBvIDxsLnNhbmZpbGlwcG9Aa3VuYnVzLmNvbT4KCkluIFJTNDg1
IG1vZGUgdGhlIHRyYW5zbWlzc2lvbiBvZiBhIGhpZ2ggcHJpb3JpdHkgY2hhcmFjdGVyIGZhaWxz
IHNpbmNlIGl0CmlzIHdyaXR0ZW4gdG8gdGhlIGRhdGEgcmVnaXN0ZXIgYmVmb3JlIHRoZSB0cmFu
c21pdHRlciBpcyBlbmFibGVkLiBGaXggdGhpcwppbiBwbDAxMV90eF9jaGFycygpIGJ5IGVuYWJs
aW5nIFJTNDg1IHRyYW5zbWlzc2lvbiBiZWZvcmUgd3JpdGluZyB0aGUKY2hhcmFjdGVyLgoKRml4
ZXM6IDhkNDc5MjM3NzI3YyAoInNlcmlhbDogYW1iYS1wbDAxMTogYWRkIFJTNDg1IHN1cHBvcnQi
KQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBMaW5vIFNhbmZpbGlw
cG8gPGwuc2FuZmlsaXBwb0BrdW5idXMuY29tPgotLS0KIGRyaXZlcnMvdHR5L3NlcmlhbC9hbWJh
LXBsMDExLmMgfCA4ICsrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3NlcmlhbC9hbWJhLXBsMDEx
LmMgYi9kcml2ZXJzL3R0eS9zZXJpYWwvYW1iYS1wbDAxMS5jCmluZGV4IGQ3NWMzOWY0NjIyYi4u
ZDhjMmYzNDU1ZWViIDEwMDY0NAotLS0gYS9kcml2ZXJzL3R0eS9zZXJpYWwvYW1iYS1wbDAxMS5j
CisrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9hbWJhLXBsMDExLmMKQEAgLTE0NjYsNiArMTQ2Niwx
MCBAQCBzdGF0aWMgYm9vbCBwbDAxMV90eF9jaGFycyhzdHJ1Y3QgdWFydF9hbWJhX3BvcnQgKnVh
cCwgYm9vbCBmcm9tX2lycSkKIAlzdHJ1Y3QgY2lyY19idWYgKnhtaXQgPSAmdWFwLT5wb3J0LnN0
YXRlLT54bWl0OwogCWludCBjb3VudCA9IHVhcC0+Zmlmb3NpemUgPj4gMTsKIAorCWlmICgodWFw
LT5wb3J0LnJzNDg1LmZsYWdzICYgU0VSX1JTNDg1X0VOQUJMRUQpICYmCisJICAgICF1YXAtPnJz
NDg1X3R4X3N0YXJ0ZWQpCisJCXBsMDExX3JzNDg1X3R4X3N0YXJ0KHVhcCk7CisKIAlpZiAodWFw
LT5wb3J0LnhfY2hhcikgewogCQlpZiAoIXBsMDExX3R4X2NoYXIodWFwLCB1YXAtPnBvcnQueF9j
aGFyLCBmcm9tX2lycSkpCiAJCQlyZXR1cm4gdHJ1ZTsKQEAgLTE0NzcsMTAgKzE0ODEsNiBAQCBz
dGF0aWMgYm9vbCBwbDAxMV90eF9jaGFycyhzdHJ1Y3QgdWFydF9hbWJhX3BvcnQgKnVhcCwgYm9v
bCBmcm9tX2lycSkKIAkJcmV0dXJuIGZhbHNlOwogCX0KIAotCWlmICgodWFwLT5wb3J0LnJzNDg1
LmZsYWdzICYgU0VSX1JTNDg1X0VOQUJMRUQpICYmCi0JICAgICF1YXAtPnJzNDg1X3R4X3N0YXJ0
ZWQpCi0JCXBsMDExX3JzNDg1X3R4X3N0YXJ0KHVhcCk7Ci0KIAkvKiBJZiB3ZSBhcmUgdXNpbmcg
RE1BIG1vZGUsIHRyeSB0byBzZW5kIHNvbWUgY2hhcmFjdGVycy4gKi8KIAlpZiAocGwwMTFfZG1h
X3R4X2lycSh1YXApKQogCQlyZXR1cm4gdHJ1ZTsKCmJhc2UtY29tbWl0OiA5MzkyOGQ0ODVkOWRm
MTJiZTcyNGNiZGYxY2FhN2QxOTdiNjUwMDFlCi0tIAoyLjM5LjAKCg==
