Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB0C179B33
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 22:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgCDVpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 16:45:54 -0500
Received: from mx01-sz.bfs.de ([194.94.69.67]:45608 "EHLO mx01-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbgCDVpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 16:45:53 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 16:45:52 EST
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx01-sz.bfs.de (Postfix) with ESMTPS id 94AF520371;
        Wed,  4 Mar 2020 22:38:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1583357912; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QkLnH+NE8c3qkE/LnlNQPG4USM8MtcA/4B/Z5q7MV94=;
        b=ox2a1lRVK9fnzc4iDIFh+2Xs0zIRwBsojXkNVowJNH0DwpX0/bc50gOOC5+uK2qfJH/AZ3
        Tar6sQOvFZvIf9dUqNYqROoKSEAVxMnsUhJeEImDzuPnkITX/7YTiIBm8SkTtLAKVhw3F7
        alPNFEjEwZpqP9jhEaoK2PZFXke8M/MTtToYdgL3atOVa0G6JF2Zkt1p1mgZES94xbobin
        96CgPo5uO1m3gvMgVHgAT9pE1zEGrsRYwJ2nbTe9nG+Tz50oSs/7zxJCOFN5E1i0lmOH0g
        gGzu/+tQni4Mj8k+TtJdQC/rqpIKRwnIKkqHgTUX1J+rFHeIdYoinVBRa7cuHQ==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1913.5; Wed, 4 Mar 2020
 22:28:31 +0100
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%6]) with mapi id
 15.01.1913.005; Wed, 4 Mar 2020 22:28:31 +0100
From:   Walter Harms <wharms@bfs.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Paul Burton <paulburton@kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: AW: [PATCH 5.5 110/176] MIPS: VPE: Fix a double free and a memory
 leak in release_vpe()
Thread-Topic: [PATCH 5.5 110/176] MIPS: VPE: Fix a double free and a memory
 leak in release_vpe()
Thread-Index: AQHV8Y196lGPcYxjR0WoJuuadsBv/Kg49D8A
Date:   Wed, 4 Mar 2020 21:28:31 +0000
Message-ID: <adf1859b4dcc497285ebbda017ece22d@bfs.de>
References: <20200303174304.593872177@linuxfoundation.org>,<20200303174317.555620066@linuxfoundation.org>
In-Reply-To: <20200303174317.555620066@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-0.33
Authentication-Results: mx01-sz.bfs.de;
        none
X-Spamd-Result: default: False [-0.33 / 7.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.980,0];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-0.33)[75.84%]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


________________________________________
Von: kernel-janitors-owner@vger.kernel.org <kernel-janitors-owner@vger.kern=
el.org> im Auftrag von Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Gesendet: Dienstag, 3. M=E4rz 2020 18:42
An: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman; stable@vger.kernel.org; Christophe JAILLET; Paul Bu=
rton; ralf@linux-mips.org; linux-mips@vger.kernel.org; kernel-janitors@vger=
.kernel.org
Betreff: [PATCH 5.5 110/176] MIPS: VPE: Fix a double free and a memory leak=
 in release_vpe()

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit bef8e2dfceed6daeb6ca3e8d33f9c9d43b926580 upstream.

Pointer on the memory allocated by 'alloc_progmem()' is stored in
'v->load_addr'. So this is this memory that should be freed by
'release_progmem()'.

'release_progmem()' is only a call to 'kfree()'.

With the current code, there is both a double free and a memory leak.
Fix it by passing the correct pointer to 'release_progmem()'.

Fixes: e01402b115ccc ("More AP / SP bits for the 34K, the Malta bits and th=
ings. Still wants")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: ralf@linux-mips.org
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/vpe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -134,7 +134,7 @@ void release_vpe(struct vpe *v)
 {
        list_del(&v->list);
        if (v->load_addr)
-               release_progmem(v);
+               release_progmem(v->load_addr);
        kfree(v);
 }


since release_progmem() is kfree() it is also possible to drop "if (v->load=
_addr)"

jm2c

re,
 wh=
