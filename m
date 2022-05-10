Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAB3521581
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiEJMiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbiEJMiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:38:05 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4B02A7C3C;
        Tue, 10 May 2022 05:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1652186042; x=1683722042;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AVZzSx7m2KvPuGPmt5Zx8G5rV5fa+SEexHw6KVQP/1c=;
  b=F3pQHXs7oWqoTIjQbuzfUu7COfBi76dXc4CSktQm8nPf3JegokRekWSs
   7j0kt+AKClr8PRrOAzz2fYpTCPLzae+Ki8lQo2vlLBcAf3Dy2RapfeSYm
   oFsxVJAZN9rd0xyDVX/Z72j+BMxUfKU65fplgdDeeXigZ/NQDzdZD8Q94
   8=;
X-IronPort-AV: E=Sophos;i="5.91,214,1647302400"; 
   d="scan'208";a="193936383"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 10 May 2022 12:33:46 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com (Postfix) with ESMTPS id 37BF941C44;
        Tue, 10 May 2022 12:33:45 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 10 May 2022 12:33:45 +0000
Received: from [0.0.0.0] (10.43.161.183) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 10 May
 2022 12:33:42 +0000
Message-ID: <5ad0f302-c1e1-b400-c3f3-a97c1cd443e8@amazon.com>
Date:   Tue, 10 May 2022 14:33:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2] KVM: PPC: Book3S PR: Enable MSR_DR for
 switch_mmu_context()
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Matt Evans <matt@ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220510111809.15987-1-graf@amazon.com>
 <f7416897-2ca5-6b2f-cfd3-30d9bcc557cd@csgroup.eu>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <f7416897-2ca5-6b2f-cfd3-30d9bcc557cd@csgroup.eu>
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D03UWA002.ant.amazon.com (10.43.160.144) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ck9uIDEwLjA1LjIyIDEzOjMxLCBDaHJpc3RvcGhlIExlcm95IHdyb3RlOgo+IExlIDEwLzA1LzIw
MjIgw6AgMTM6MTgsIEFsZXhhbmRlciBHcmFmIGEgw6ljcml0IDoKPj4gQ29tbWl0IDg2Mzc3MWEy
OGUyNyAoInBvd2VycGMvMzJzOiBDb252ZXJ0IHN3aXRjaF9tbXVfY29udGV4dCgpIHRvIEMiKQo+
PiBtb3ZlZCB0aGUgc3dpdGNoX21tdV9jb250ZXh0KCkgdG8gQy4gV2hpbGUgaW4gcHJpbmNpcGxl
IGEgZ29vZCBpZGVhLCBpdAo+PiBtZWFudCB0aGF0IHRoZSBmdW5jdGlvbiBub3cgdXNlcyB0aGUg
c3RhY2suIFRoZSBzdGFjayBpcyBub3QgYWNjZXNzaWJsZQo+PiBmcm9tIHJlYWwgbW9kZSB0aG91
Z2guCj4+Cj4+IFNvIHRvIGtlZXAgY2FsbGluZyB0aGUgZnVuY3Rpb24sIGxldCdzIHR1cm4gb24g
TVNSX0RSIHdoaWxlIHdlIGNhbGwgaXQuCj4+IFRoYXQgd2F5LCBhbGwgcG9pbnRlciByZWZlcmVu
Y2VzIHRvIHRoZSBzdGFjayBhcmUgaGFuZGxlZCB2aXJ0dWFsbHkuCj4gSXMgdGhlIHN5c3RlbSBy
ZWFkeSB0byBoYW5kbGUgYSBEU0kgaW4gY2FzZSB0aGUgc3RhY2sgaXMgbm90IG1hcHBlZCA/CgoK
QSBEU0kgaXRzZWxmIHdpbGwgYmUgYW4gaW50ZXJydXB0IGFnYWluIHdoaWNoIHdpbGwgaW4gdHVy
biBkZXN0cm95IHRoZSAKU1BSRyB0aGF0IHdlJ3JlIHNhdmluZy4gR3Vlc3MgSSB3YXMgdHJ5aW5n
IHRvIGJlIHRvbyBzbWFydCA6KS4gSSdsbCB1c2UgCk1hdHQncyBvcmlnaW5hbCBzdWdnZXN0aW9u
IGFuZCBqdXN0IHB1dCBpdCBvbiB0aGUgc3RhY2suCgoKPj4gSW4gYWRkaXRpb24sIG1ha2Ugc3Vy
ZSB0byBzYXZlL3Jlc3RvcmUgcjEyIGluIGFuIFNQUkcsIGFzIGl0IG1heSBnZXQKPj4gY2xvYmJl
cmVkIGJ5IHRoZSBDIGZ1bmN0aW9uLgo+Pgo+PiBSZXBvcnRlZC1ieTogTWF0dCBFdmFucyA8bWF0
dEBvemxhYnMub3JnPgo+PiBGaXhlczogODYzNzcxYTI4ZTI3ICgicG93ZXJwYy8zMnM6IENvbnZl
cnQgc3dpdGNoX21tdV9jb250ZXh0KCkgdG8gQyIpCj4gT29wcywgc29ycnkgZm9yIHRoYXQuIEkg
ZGlkbid0IHJlYWxpc2UgdGhhdCB0aGVyZSB3YXMgb3RoZXIgY2FsbGVycyB0bwo+IHN3aXRjaF9t
bXVfY29udGV4dCgpIHRoYW4gc3dpdGNoX21tX2lycXNfb2ZmKCkuCgoKTm8gd29ycmllcywgdGhl
IGNvbXBpbGVkIEMgdmVyc2lvbiBsb29rcyBhIGxvdCBuaWNlciB0aGFuIHRoZSBwcmV2aW91cyAK
YXNtIG9uZSAtIGFuZCBpdCB3YXMgYSBnb29kIHdheSB0byBpZGVudGlmeSB3aGV0aGVyIHRoZXJl
IHN0aWxsIGFyZSAKdXNlcnMgb2YgS1ZNIG9uIEJvb2szUyAzMmJpdCBvdXQgdGhlcmUgOikKCgpB
bGV4CgoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0
ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdl
ciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1
cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5
CgoK

