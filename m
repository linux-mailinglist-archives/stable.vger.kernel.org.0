Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2ABD5737C5
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiGMNpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiGMNpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:45:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD243FDC;
        Wed, 13 Jul 2022 06:45:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83449339BF;
        Wed, 13 Jul 2022 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657719949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DLPq+/BqRirohgnuISi9vglE+Gp1k13nS0xAJRU0hxA=;
        b=JWViSCZZiYlLXYo9S3PkCap+JaYexGbYwXLA2k8HA9CZghCY8xl4CK9ixCwl0nvVy0izNH
        w/TelSGNw/UhHTLny2iy5VCqWP8DIqttS+SnlxpkJHeMjNETRe0TBdaluvzS5jCXES+qGP
        a1L7Dei3QklJbrQUjkP/tq1RIsRJ30U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E914C13754;
        Wed, 13 Jul 2022 13:45:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yt9rN4zMzmKQTQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 13 Jul 2022 13:45:48 +0000
Message-ID: <a8d0763f-7757-38ec-f9c1-5be6629ee6b2@suse.com>
Date:   Wed, 13 Jul 2022 15:45:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>,
        Chuck Zmudzinski <brchuckz@netscape.net>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
 <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
 <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
In-Reply-To: <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eAnzHIkgnyu5Zz2tML6wHnxq"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------eAnzHIkgnyu5Zz2tML6wHnxq
Content-Type: multipart/mixed; boundary="------------yfXlC0JibNNYMYRQRYhySi2z";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>, Chuck Zmudzinski <brchuckz@netscape.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Jane Chu <jane.chu@oracle.com>,
 Tianyu Lan <Tianyu.Lan@microsoft.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sean Christopherson <seanjc@google.com>, xen-devel@lists.xenproject.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Message-ID: <a8d0763f-7757-38ec-f9c1-5be6629ee6b2@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <e0faeb99-6c32-a836-3f6b-269318a6b5a6@suse.com>
 <3d3f0766-2e06-428b-65bb-5d9f778a2baf@netscape.net>
 <e15c0030-3270-f524-17e4-c482e971eb88@suse.com>
 <775493aa-618c-676f-8aa4-d1667cf2ca78@netscape.net>
 <c2ead659-d0aa-5b1f-0079-ce7c02970b35@netscape.net>
 <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>
In-Reply-To: <1d06203b-97ff-e7eb-28ae-4cdbc7569218@suse.com>

--------------yfXlC0JibNNYMYRQRYhySi2z
Content-Type: multipart/mixed; boundary="------------fDVm7r2YKWmsXPXC84AR5mO6"

--------------fDVm7r2YKWmsXPXC84AR5mO6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTMuMDcuMjIgMTU6MzQsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAxMy4wNy4yMDIy
IDEzOjEwLCBDaHVjayBabXVkemluc2tpIHdyb3RlOg0KPj4gT24gNy8xMy8yMDIyIDY6MzYg
QU0sIENodWNrIFptdWR6aW5za2kgd3JvdGU6DQo+Pj4gT24gNy8xMy8yMDIyIDU6MDkgQU0s
IEphbiBCZXVsaWNoIHdyb3RlOg0KPj4+PiBPbiAxMy4wNy4yMDIyIDEwOjUxLCBDaHVjayBa
bXVkemluc2tpIHdyb3RlOg0KPj4+Pj4gT24gNy8xMy8yMiAyOjE4IEFNLCBKYW4gQmV1bGlj
aCB3cm90ZToNCj4+Pj4+PiBPbiAxMy4wNy4yMDIyIDAzOjM2LCBDaHVjayBabXVkemluc2tp
IHdyb3RlOg0KPj4+Pj4+PiB2MjogKkFkZCBmb3JjZV9wYXRfZGlzYWJsZWQgdmFyaWFibGUg
dG8gZml4ICJub3BhdCIgb24gWGVuIFBWIChKYW4gQmV1bGljaCkNCj4+Pj4+Pj4gICAgICAq
QWRkIHRoZSBuZWNlc3NhcnkgY29kZSB0byBpbmNvcnBvcmF0ZSB0aGUgIm5vcGF0IiBmaXgN
Cj4+Pj4+Pj4gICAgICAqdm9pZCBpbml0X2NhY2hlX21vZGVzKHZvaWQpIC0+IHZvaWQgX19p
bml0IGluaXRfY2FjaGVfbW9kZXModm9pZCkNCj4+Pj4+Pj4gICAgICAqQWRkIEphbiBCZXVs
aWNoIGFzIENvLWRldmVsb3BlciAoSmFuIGhhcyBub3Qgc2lnbmVkIG9mZiB5ZXQpDQo+Pj4+
Pj4+ICAgICAgKkV4cGFuZCB0aGUgY29tbWl0IG1lc3NhZ2UgdG8gaW5jbHVkZSByZWxldmFu
dCBwYXJ0cyBvZiB0aGUgY29tbWl0DQo+Pj4+Pj4+ICAgICAgIG1lc3NhZ2Ugb2YgSmFuIEJl
dWxpY2gncyBwcm9wb3NlZCBwYXRjaCBmb3IgdGhpcyBwcm9ibGVtDQo+Pj4+Pj4+ICAgICAg
KkZpeCAnZWxzZSBpZiAuLi4geycgcGxhY2VtZW50IGFuZCBpbmRlbnRhdGlvbg0KPj4+Pj4+
PiAgICAgICpSZW1vdmUgaW5kaWNhdGlvbiB0aGUgYmFja3BvcnQgdG8gc3RhYmxlIGJyYW5j
aGVzIGlzIG9ubHkgYmFjayB0byA1LjE3LnkNCj4+Pj4+Pj4NCj4+Pj4+Pj4gSSB0aGluayB0
aGVzZSBjaGFuZ2VzIGFkZHJlc3MgYWxsIHRoZSBjb21tZW50cyBvbiB0aGUgb3JpZ2luYWwg
cGF0Y2gNCj4+Pj4+Pj4NCj4+Pj4+Pj4gSSBhZGRlZCBKYW4gQmV1bGljaCBhcyBhIENvLWRl
dmVsb3BlciBiZWNhdXNlIEp1ZXJnZW4gR3Jvc3MgYXNrZWQgbWUgdG8NCj4+Pj4+Pj4gaW5j
bHVkZSBKYW4ncyBpZGVhIGZvciBmaXhpbmcgIm5vcGF0IiB0aGF0IHdhcyBtaXNzaW5nIGZy
b20gdGhlIGZpcnN0DQo+Pj4+Pj4+IHZlcnNpb24gb2YgdGhlIHBhdGNoLg0KPj4+Pj4+DQo+
Pj4+Pj4gWW91J3ZlIHN1ZmZpY2llbnRseSBhbHRlcmVkIHRoaXMgY2hhbmdlIHRvIGNsZWFy
bHkgbm8gbG9uZ2VyIHdhbnQgbXkNCj4+Pj4+PiBTLW8tYjsgdW5mb3J0dW5hdGVseSBpbiBm
YWN0IEkgdGhpbmsgeW91IGJyb2tlIHRoaW5nczoNCj4+Pj4+DQo+Pj4+PiBXZWxsLCBJIGhv
cGUgd2UgY2FuIGNvbWUgdG8gYW4gYWdyZWVtZW50IHNvIEkgaGF2ZQ0KPj4+Pj4geW91ciBT
LW8tYi4gQnV0IHRoYXQgd291bGQgcHJvYmFibHkgcmVxdWlyZSBtZSB0byByZW1vdmUNCj4+
Pj4+IEp1ZXJnZW4ncyBSLWIuDQo+Pj4+Pg0KPj4+Pj4+PiBAQCAtMjkyLDcgKzI5NCw3IEBA
IHZvaWQgaW5pdF9jYWNoZV9tb2Rlcyh2b2lkKQ0KPj4+Pj4+PiAgIAkJcmRtc3JsKE1TUl9J
QTMyX0NSX1BBVCwgcGF0KTsNCj4+Pj4+Pj4gICAJfQ0KPj4+Pj4+PiAgIA0KPj4+Pj4+PiAt
CWlmICghcGF0KSB7DQo+Pj4+Pj4+ICsJaWYgKCFwYXQgfHwgcGF0X2ZvcmNlX2Rpc2FibGVk
KSB7DQo+Pj4+Pj4NCj4+Pj4+PiBCeSBjaGVja2luZyB0aGUgbmV3IHZhcmlhYmxlIGhlcmUg
Li4uDQo+Pj4+Pj4NCj4+Pj4+Pj4gICAJCS8qDQo+Pj4+Pj4+ICAgCQkgKiBObyBQQVQuIEVt
dWxhdGUgdGhlIFBBVCB0YWJsZSB0aGF0IGNvcnJlc3BvbmRzIHRvIHRoZSB0d28NCj4+Pj4+
Pj4gICAJCSAqIGNhY2hlIGJpdHMsIFBXVCAoV3JpdGUgVGhyb3VnaCkgYW5kIFBDRCAoQ2Fj
aGUgRGlzYWJsZSkuDQo+Pj4+Pj4+IEBAIC0zMTMsNiArMzE1LDE2IEBAIHZvaWQgaW5pdF9j
YWNoZV9tb2Rlcyh2b2lkKQ0KPj4+Pj4+PiAgIAkJICovDQo+Pj4+Pj4+ICAgCQlwYXQgPSBQ
QVQoMCwgV0IpIHwgUEFUKDEsIFdUKSB8IFBBVCgyLCBVQ19NSU5VUykgfCBQQVQoMywgVUMp
IHwNCj4+Pj4+Pj4gICAJCSAgICAgIFBBVCg0LCBXQikgfCBQQVQoNSwgV1QpIHwgUEFUKDYs
IFVDX01JTlVTKSB8IFBBVCg3LCBVQyk7DQo+Pj4+Pj4NCj4+Pj4+PiAuLi4geW91IHB1dCBp
biBwbGFjZSBhIHNvZnR3YXJlIHZpZXcgd2hpY2ggZG9lc24ndCBtYXRjaCBoYXJkd2FyZS4g
SQ0KPj4+Pj4+IGNvbnRpbnVlIHRvIHRoaW5rIHRoYXQgLi4uDQo+Pj4+Pj4NCj4+Pj4+Pj4g
Kwl9IGVsc2UgaWYgKCFwYXRfYnBfZW5hYmxlZCkgew0KPj4+Pj4+DQo+Pj4+Pj4gLi4uIHRo
ZSB2YXJpYWJsZSB3YW50cyBjaGVja2luZyBoZXJlIGluc3RlYWQgKGF0IHdoaWNoIHBvaW50
LCB5ZXMsDQo+Pj4+Pj4gdGhpcyBjb21lcyBxdWl0ZSBjbG9zZSB0byBzaW1wbHkgYmVpbmcg
YSB2MiBvZiBteSBvcmlnaW5hbCBwYXRjaCkuDQo+Pj4+Pj4NCj4+Pj4+PiBCeSB1c2luZyAh
cGF0X2JwX2VuYWJsZWQgaGVyZSB5b3UgYWN0dWFsbHkgYnJvYWRlbiB3aGVyZSB0aGUgY2hh
bmdlDQo+Pj4+Pj4gd291bGQgdGFrZSBlZmZlY3QuIElpcmMgQm9yaXMgaGFkIGFza2VkIHRv
IG5hcnJvdyB0aGluZ3MgKGJlc2lkZXMNCj4+Pj4+PiB2b2ljaW5nIG9wcG9zaXRpb24gdG8g
dGhpcyBhcHByb2FjaCBhbHRvZ2V0aGVyKS4gRXZlbiB3aXRob3V0IHRoYXQNCj4+Pj4+PiBy
ZXF1ZXN0IEkgd29uZGVyIHdoZXRoZXIgeW91IGFyZW4ndCBnb2luZyB0byBmYXIgd2l0aCB0
aGlzLg0KPj4+Pj4+DQo+Pj4+Pj4gSmFuDQo+Pj4+Pg0KPj4+Pj4gSSB0aG91Z2h0IGFib3V0
IGNoZWNraW5nIGZvciB0aGUgYWRtaW5pc3RyYXRvcidzICJub3BhdCINCj4+Pj4+IHNldHRp
bmcgd2hlcmUgeW91IHN1Z2dlc3Qgd2hpY2ggd291bGQgbGltaXQgdGhlIGVmZmVjdA0KPj4+
Pj4gb2YgIm5vcGF0IiB0byBub3QgcmVwb3J0aW5nIFBBVCBhcyBlbmFibGVkIHRvIGRldmlj
ZQ0KPj4+Pj4gZHJpdmVycyB3aG8gcXVlcnkgZm9yIFBBVCBhdmFpbGFiaWxpdHkgdXNpbmcg
cGF0X2VuYWJsZWQoKS4NCj4+Pj4+IFRoZSBtYWluIHJlYXNvbiBJIGRpZCBub3QgZG8gdGhh
dCBpcyB0aGF0IGR1ZSB0byB0aGUgZmFjdA0KPj4+Pj4gdGhhdCB3ZSBjYW5ub3Qgd3JpdGUg
dG8gdGhlIFBBVCBNU1IsIHdlIGNhbm5vdCByZWFsbHkNCj4+Pj4+IGRpc2FibGUgUEFULiBC
dXQgd2UgY29tZSBjbG9zZXIgdG8gcmVzcGVjdGluZyB0aGUgd2lzaGVzDQo+Pj4+PiBvZiB0
aGUgYWRtaW5pc3RyYXRvciBieSBjb25maWd1cmluZyB0aGUgY2FjaGluZyBtb2RlcyBhcw0K
Pj4+Pj4gaWYgUEFUIGlzIGFjdHVhbGx5IGRpc2FibGVkIGJ5IHRoZSBoYXJkd2FyZSBvciBm
aXJtd2FyZQ0KPj4+Pj4gd2hlbiBpbiBmYWN0IGl0IGlzIG5vdC4NCj4+Pj4+DQo+Pj4+PiBX
aGF0IHdvdWxkIHlvdSBwcm9wb3NlIGxvZ2dpbmcgYXMgYSBtZXNzYWdlIHdoZW4NCj4+Pj4+
IHdlIHJlcG9ydCBQQVQgYXMgZGlzYWJsZWQgdmlhIHBhdF9lbmFibGVkKCk/IFRoZSBtYWlu
DQo+Pj4+PiByZWFzb24gSSBkaWQgbm90IGNob29zZSB0byBjaGVjayB0aGUgbmV3IHZhcmlh
YmxlIGluIHRoZQ0KPj4+Pj4gbmV3ICdlbHNlIGlmJyBibG9jayBpcyB0aGF0IEkgY291bGQg
bm90IGZpZ3VyZSBvdXQgd2hhdCB0bw0KPj4+Pj4gdGVsbCB0aGUgYWRtaW5pc3RyYXRvciBp
biB0aGF0IGNhc2UuIEkgdGhpbmsgd2Ugd291bGQgaGF2ZQ0KPj4+Pj4gdG8gbG9nIHNvbWV0
aGluZyBsaWtlLCAibm9wYXQgaXMgc2V0LCBidXQgd2UgY2Fubm90IGRpc2FibGUNCj4+Pj4+
IFBBVCwgZG9pbmcgb3VyIGJlc3QgdG8gZGlzYWJsZSBQQVQgYnkgbm90IHJlcG9ydGluZyBQ
QVQNCj4+Pj4+IGFzIGVuYWJsZWQgdmlhIHBhdF9lbmFibGVkKCksIGJ1dCB0aGF0IGRvZXMg
bm90IGd1YXJhbnRlZQ0KPj4+Pj4gdGhhdCBrZXJuZWwgZHJpdmVycyBhbmQgY29tcG9uZW50
cyBjYW5ub3QgdXNlIFBBVCBpZiB0aGV5DQo+Pj4+PiBxdWVyeSBmb3IgUEFUIHN1cHBvcnQg
dXNpbmcgYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1BBVCkNCj4+Pj4+IGluc3RlYWQgb2Yg
cGF0X2VuYWJsZWQoKS4iIEhvd2V2ZXIsIEkgYWNrbm93bGVkZ2UgV0MgbWFwcGluZ3MNCj4+
Pj4+IHdvdWxkIHN0aWxsIGJlIGRpc2FibGVkIGJlY2F1c2UgYXJjaF9jYW5fcGNpX21tYXBf
d2MoKSB3aWxsDQo+Pj4+PiBiZSBmYWxzZSBpZiBwYXRfZW5hYmxlZCgpIGlzIGZhbHNlLg0K
Pj4+Pj4NCj4+Pj4+IFBlcmhhcHMgd2UgYWxzbyBuZWVkIHRvIGxvZyBzb21ldGhpbmcgaWYg
d2Uga2VlcCB0aGUNCj4+Pj4+IGNoZWNrIGZvciAibm9wYXQiIHdoZXJlIEkgcGxhY2VkIGl0
LiBXZSBjb3VsZCBzYXkgc29tZXRoaW5nDQo+Pj4+PiBsaWtlOiAibm9wYXQgaXMgc2V0LCBi
dXQgd2UgY2Fubm90IGRpc2FibGUgaGFyZHdhcmUvZmlybXdhcmUNCj4+Pj4+IFBBVCBzdXBw
b3J0LCBzbyB3ZSBhcmUgZW11bGF0aW5nIGFzIGlmIHRoZXJlIGlzIG5vIFBBVCBzdXBwb3J0
DQo+Pj4+PiB3aGljaCBwdXRzIGluIHBsYWNlIGEgc29mdHdhcmUgdmlldyB0aGF0IGRvZXMg
bm90IG1hdGNoDQo+Pj4+PiBoYXJkd2FyZS4iDQo+Pj4+Pg0KPj4+Pj4gTm8gbWF0dGVyIHdo
YXQsIGJlY2F1c2Ugd2UgY2Fubm90IHdyaXRlIHRvIFBBVCBNU1IgaW4NCj4+Pj4+IHRoZSBY
ZW4gUFYgY2FzZSwgd2UgcHJvYmFibHkgbmVlZCB0byBsb2cgc29tZXRoaW5nIHRvDQo+Pj4+
PiBleHBsYWluIHRoZSBwcm9ibGVtcyBhc3NvY2lhdGVkIHdpdGggdHJ5aW5nIHRvIGhvbm9y
IHRoZQ0KPj4+Pj4gYWRtaW5pc3RyYXRvcidzIHJlcXVlc3QuIEFsc28sIHdoYXQgbG9nIGxl
dmVsIHNob3VsZCBpdCBiZS4NCj4+Pj4+IFNob3VsZCBpdCBiZSBhIHByX3dhcm4gaW5zdGVh
ZCBvZiBhIHByX2luZm8/DQo+Pj4+DQo+Pj4+IEknbSBhZnJhaWQgSSdtIHRoZSB3cm9uZyBv
bmUgdG8gYW5zd2VyIGxvZ2dpbmcgcXVlc3Rpb25zLiBBcyB5b3UNCj4+Pj4gY2FuIHNlZSBm
cm9tIG15IG9yaWdpbmFsIHBhdGNoLCBJIGRpZG4ndCBhZGQgYW55IG5ldyBsb2dnaW5nIChh
bmQNCj4+Pj4gbm8gYWRkaXRpb24gd2FzIHJlcXVlc3RlZCBpbiB0aGUgY29tbWVudHMgdGhh
dCBJIGhhdmUgZ290KS4gSSBhbHNvDQo+Pj4+IGRvbid0IHRoaW5rICJub3BhdCIgaGFzIGV2
ZXIgbWVhbnQgImRpc2FibGUgUEFUIiwgYXMgdGhlIGZlYXR1cmUNCj4+Pj4gaXMgZWl0aGVy
IHRoZXJlIG9yIG5vdC4gSW5zdGVhZCBJIHRoaW5rIGl0IHdhcyBhbHdheXMgc2VlbiBhcw0K
Pj4+PiAiZGlzYWJsZSBmaWRkbGluZyB3aXRoIFBBVCIsIHdoaWNoIGJ5IGltcGxpY2F0aW9u
IG1lYW5zIHVzaW5nDQo+Pj4+IHdoYXRldmVyIGlzIHRoZXJlIChpZiB0aGUgZmVhdHVyZSAv
IE1TUiBpdHNlbGYgaXMgYXZhaWxhYmxlKS4NCj4+Pg0KPj4+IElJUkMsIEkgZG8gdGhpbmsg
SSBtZW50aW9uZWQgaW4gdGhlIGNvbW1lbnRzIG9uIHlvdXIgcGF0Y2ggdGhhdA0KPj4+IGl0
IHdvdWxkIGJlIHByZWZlcmFibGUgdG8gbWVudGlvbiBpbiB0aGUgY29tbWl0IG1lc3NhZ2Ug
dGhhdA0KPj4+IHlvdXIgcGF0Y2ggd291bGQgY2hhbmdlIHRoZSBjdXJyZW50IGJlaGF2aW9y
IG9mICJub3BhdCIgb24NCj4+PiBYZW4uIFRoZSBxdWVzdGlvbiBpcywgaG93IG11Y2ggZG8g
d2Ugd2FudCB0byBjaGFuZ2UgdGhlDQo+Pj4gY3VycmVudCBiZWhhdmlvciBvZiAibm9wYXQi
IG9uIFhlbi4gSSB0aGluayBpZiB3ZSBoYXZlIHRvIGNoYW5nZQ0KPj4+IHRoZSBjdXJyZW50
IGJlaGF2aW9yIG9mICJub3BhdCIgb24gWGVuIGFuZCBpZiB3ZSBhcmUgZ29pbmcNCj4+PiB0
byBwcm9wYWdhdGUgdGhhdCBjaGFuZ2UgdG8gYWxsIGN1cnJlbnQgc3RhYmxlIGJyYW5jaGVz
IGFsbA0KPj4+IHRoZSB3YXkgYmFjayB0byA0LjkueSwsIHdlIGJldHRlciBtYWtlIGEgbG90
IG9mIG5vaXNlIGFib3V0DQo+Pj4gd2hhdCB3ZSBhcmUgZG9pbmcgaGVyZS4NCj4+Pg0KPj4+
IENodWNrDQo+Pg0KPj4gQW5kIGluIGFkZGl0aW9uLCBpZiB3ZSBhcmUgZ29pbmcgdG8gYmFj
a3BvcnQgdGhpcyBwYXRjaCB0bw0KPj4gYWxsIGN1cnJlbnQgc3RhYmxlIGJyYW5jaGVzLCB3
ZSBiZXR0ZXIgaGF2ZSBhIHJlYWxseSwgcmVhbGx5LA0KPj4gZ29vZCByZWFzb24gZm9yIGNo
YW5naW5nIHRoZSBiZWhhdmlvciBvZiAibm9wYXQiIG9uIFhlbi4NCj4+DQo+PiBEb2VzIHN1
Y2ggYSByZWFzb24gZXhpc3Q/DQo+IA0KPiBXZWxsLCB0aGUgc2ltcGxlIHJlYXNvbiBpczog
SXQgZG9lc24ndCB3b3JrIHRoZSBzYW1lIHdheSB1bmRlciBYZW4NCj4gYW5kIG5vbi1YZW4g
KGluIHR1cm4gYmVjYXVzZSwgYmVmb3JlIG15IHBhdGNoIG9yIHdoYXRldmVyIGVxdWl2YWxl
bnQNCj4gd29yaywgdGhpbmdzIGRvbid0IHdvcmsgcHJvcGVybHkgYW55d2F5LCBQQVQtd2lz
ZSkuIFlldCBpdCBkZWZpbml0ZWx5DQo+IG91Z2h0IHRvIGJlaGF2ZSB0aGUgc2FtZSBldmVy
eXdoZXJlLCBpbW8uDQoNClRoZXJlIGlzIERvY3VtZW50YXRpb24veDg2L3BhdC5yc3Qgd2hp
Y2ggcmF0aGVyIGNsZWFybHkgc3RhdGVzLCBob3cNCiJub3BhdCIgaXMgbWVhbnQgdG8gd29y
ay4gSXQgc2hvdWxkIG5vdCBjaGFuZ2UgdGhlIGNvbnRlbnRzIG9mIHRoZQ0KUEFUIE1TUiBh
bmQga2VlcCBpdCBqdXN0IGFzIGl0IHdhcyBzZXQgYXQgYm9vdCB0aW1lICh0aGUgZG9jIHRh
bGtzDQphYm91dCB0aGUgIkJJT1MiIHNldHRpbmcgb2YgdGhlIE1TUiwgYW5kIEkgZ3Vlc3Mg
aW4gdGhlIFhlbiBjYXNlDQp0aGUgaHlwZXJ2aXNvciBpcyBraW5kIG9mIGFjdGluZyBhcyB0
aGUgQklPUykuDQoNClRoZSBxdWVzdGlvbiBpcywgd2hldGhlciAibm9wYXQiIG5lZWRzIHRv
IGJlIHRyYW5zbGF0ZWQgdG8NCnBhdF9lbmFibGVkKCkgcmV0dXJuaW5nICJmYWxzZSIuIEkn
dmUgZm91bmQgZXhhY3RseSBvbmUgY2FzZSB3aGVyZQ0KIm5vcGF0IiBzZWVtcyB0byBiZSBy
ZXF1aXJlZCBmb3IgYSBkcml2ZXIgdG8gd29yayBjb3JyZWN0bHksIGJ1dA0KdGhpcyBkcml2
ZXIgKGRyaXZlcnMvbWVkaWEvcGNpL2l2dHYvaXZ0dmZiLmMpIHNlZW1zIHRvIHJlbHkgb24N
Ck1UUlIgYXZhaWxhYmlsaXR5LCB3aGljaCBpc24ndCBzdXBwb3J0ZWQgaW4gWGVuIFBWIGd1
ZXN0cy4NCg0KT3RoZXIgdGhhbiB0aGF0IHRoZSAibm9wYXQiIG9wdGlvbiBzZWVtcyB0byBi
ZSBhIGNoaWNrZW4gYml0IGZyb20NCnRoZSBlYXJseSBkYXlzIG9mIFBBVCB1c2FnZSwgd2hp
Y2ggcHJvYmFibHkgaXNuJ3QgcmVhbGx5IG5lZWRlZCBhbnkNCm1vcmUuIFNvIEkgd291bGRu
J3QgYmUgd29ycmllZCB0byBkcm9wICJub3BhdCIgaGF2aW5nIGFueSBlZmZlY3QNCm9uIHRo
ZSBzeXN0ZW0gaW4gWGVuIFBWIGd1ZXN0cy4NCg0KT24gYmFyZSBtZXRhbCBpdCBzaG91bGQg
c3RpbGwgd29yaywgb2YgY291cnNlLCBpZiBvbmx5IGZvciBzYWlkDQpkcml2ZXIuDQoNCj4+
IE9yIHBlcmhhcHMsIEp1ZXJnZW4sIGNvdWxkIHlvdQ0KPj4gYWNjZXB0IGEgdjMgb2YgbXkg
cGF0Y2ggdGhhdCBkb2VzIG5vdCBuZWVkIHRvIGRlY2lkZQ0KPj4gaG93IHRvIGJhY2twb3J0
IHRoZSBjaGFuZ2UgdG8gIm5vcGF0IiB0byB0aGUgc3RhYmxlIGJyYW5jaGVzDQo+PiB0aGF0
IGFyZSBhZmZlY3RlZCBieSB0aGUgY3VycmVudCBiZWhhdmlvciBvZiAibm9wYXQiIG9uIFhl
bj8NCg0KTm90ZSB0aGF0IGl0IGlzIG5vdCBtZSB0byBhY2NlcHQgc3VjaCBhIHBhdGNoLCB0
aGlzIHdvdWxkIGJlIG9uZQ0Kb2YgdGhlIHg4NiBtYWludGFpbmVycyAoZS5nLiBCb3Jpcyku
DQoNCg0KSnVlcmdlbg0K
--------------fDVm7r2YKWmsXPXC84AR5mO6
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------fDVm7r2YKWmsXPXC84AR5mO6--

--------------yfXlC0JibNNYMYRQRYhySi2z--

--------------eAnzHIkgnyu5Zz2tML6wHnxq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLOzIwFAwAAAAAACgkQsN6d1ii/Ey/D
rggAj385VrlW57TfBtu7McoBb3Kj0MU9yBGd+CQrlBSHTJfslyOBhg46flmlyue93FL/Cc7XMUH8
kPTZVTyCWzyTTAeuEc/MQNYEByQ/aYte9Vjrfa2IwScEpm05a87I+wNkbsDSmAyA8Ubbv6bFk3sI
TGBg5IYRykS8xkDKPh7aLJwuaDfkVdjeKRHVSF6sR3hrfBRAzoKREPB9hZAInPWIz3XEk6HKr8ne
PzTo1GktEIGQmtAOL/iQ+5L3YMr+pBjikAdXmzt9X1+H+xRBczdmfJOSwwEuddmKSf4gji2vd1pZ
M0+5uwwNvFi4rOHGLT2HvVBeAMIMBJv6Gmtc6jqICQ==
=/Bby
-----END PGP SIGNATURE-----

--------------eAnzHIkgnyu5Zz2tML6wHnxq--
