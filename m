Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809A951A11D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiEDNns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 09:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235194AbiEDNnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 09:43:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F4222B28;
        Wed,  4 May 2022 06:40:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 28B57210DB;
        Wed,  4 May 2022 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651671610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P3L8WfScLSRH1WI2OZY7AnhEganXihLXSAJyDojrSeM=;
        b=Fk5VhujveqOe+22CV+xy4pe1FB8tjhA8zmVtCswChKBR1lE48OBFdSCQro6wZwNieh3MIU
        VX/25koisNCEm21sYdalDZeVWVlqxG1DYFs503aAAf7BQfJZMnNNtnalXJXTZClu9tW+Ck
        NNY5GIhJSsWqL/xmDDSFPXxyMDm+MCA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C10AD132C4;
        Wed,  4 May 2022 13:40:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gtoeLTmCcmIffwAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 04 May 2022 13:40:09 +0000
Message-ID: <7fa956e0-98dd-4bce-033b-8566f1b7cfc6@suse.com>
Date:   Wed, 4 May 2022 15:40:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] arm64: paravirt: Use RCU read locks to guard
 stolen_time
Content-Language: en-US
To:     Elliot Berman <quic_eberman@quicinc.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Murali Nalajala <quic_mnalajal@quicinc.com>,
        stable@vger.kernel.org
References: <20220428183536.2866667-1-quic_eberman@quicinc.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220428183536.2866667-1-quic_eberman@quicinc.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------xuyclinqwvjtwpIMj7eZwjJz"
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------xuyclinqwvjtwpIMj7eZwjJz
Content-Type: multipart/mixed; boundary="------------dRLRymBekbLvthqZxssmtJ0j";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Elliot Berman <quic_eberman@quicinc.com>,
 "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
 Alexey Makhalov <amakhalov@vmware.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
 virtualization@lists.linux-foundation.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Murali Nalajala <quic_mnalajal@quicinc.com>, stable@vger.kernel.org
Message-ID: <7fa956e0-98dd-4bce-033b-8566f1b7cfc6@suse.com>
Subject: Re: [PATCH v2] arm64: paravirt: Use RCU read locks to guard
 stolen_time
References: <20220428183536.2866667-1-quic_eberman@quicinc.com>
In-Reply-To: <20220428183536.2866667-1-quic_eberman@quicinc.com>

--------------dRLRymBekbLvthqZxssmtJ0j
Content-Type: multipart/mixed; boundary="------------Lqc0Jx82gB2MJ5eOgbe3v0Ti"

--------------Lqc0Jx82gB2MJ5eOgbe3v0Ti
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjguMDQuMjIgMjA6MzUsIEVsbGlvdCBCZXJtYW4gd3JvdGU6DQo+IEZyb206IFByYWty
dXRoaSBEZWVwYWsgSGVyYWd1IDxxdWljX3BoZXJhZ3VAcXVpY2luYy5jb20+DQo+IA0KPiBE
dXJpbmcgaG90cGx1ZywgdGhlIHN0b2xlbiB0aW1lIGRhdGEgc3RydWN0dXJlIGlzIHVubWFw
cGVkIGFuZCBtZW1zZXQuDQo+IFRoZXJlIGlzIGEgcG9zc2liaWxpdHkgb2YgdGhlIHRpbWVy
IElSUSBiZWluZyB0cmlnZ2VyZWQgYmVmb3JlIG1lbXNldA0KPiBhbmQgc3RvbGVuIHRpbWUg
aXMgZ2V0dGluZyB1cGRhdGVkIGFzIHBhcnQgb2YgdGhpcyB0aW1lciBJUlEgaGFuZGxlci4g
VGhpcw0KPiBjYXVzZXMgdGhlIGJlbG93IGNyYXNoIGluIHRpbWVyIGhhbmRsZXIgLQ0KPiAN
Cj4gICAgWyAzNDU3LjQ3MzEzOV1bICAgIEM1XSBVbmFibGUgdG8gaGFuZGxlIGtlcm5lbCBw
YWdpbmcgcmVxdWVzdCBhdCB2aXJ0dWFsIGFkZHJlc3MgZmZmZmZmYzAzZGYwNTE0OA0KPiAg
ICAuLi4NCj4gICAgWyAzNDU4LjE1NDM5OF1bICAgIEM1XSBDYWxsIHRyYWNlOg0KPiAgICBb
IDM0NTguMTU3NjQ4XVsgICAgQzVdICBwYXJhX3N0ZWFsX2Nsb2NrKzB4MzAvMHg1MA0KPiAg
ICBbIDM0NTguMTYyMzE5XVsgICAgQzVdICBpcnF0aW1lX2FjY291bnRfcHJvY2Vzc190aWNr
KzB4MzAvMHgxOTQNCj4gICAgWyAzNDU4LjE2ODE0OF1bICAgIEM1XSAgYWNjb3VudF9wcm9j
ZXNzX3RpY2srMHgzYy8weDI4MA0KPiAgICBbIDM0NTguMTczMjc0XVsgICAgQzVdICB1cGRh
dGVfcHJvY2Vzc190aW1lcysweDVjLzB4ZjQNCj4gICAgWyAzNDU4LjE3ODMxMV1bICAgIEM1
XSAgdGlja19zY2hlZF90aW1lcisweDE4MC8weDM4NA0KPiAgICBbIDM0NTguMTgzMTY0XVsg
ICAgQzVdICBfX3J1bl9ocnRpbWVyKzB4MTYwLzB4NTdjDQo+ICAgIFsgMzQ1OC4xODc3NDRd
WyAgICBDNV0gIGhydGltZXJfaW50ZXJydXB0KzB4MjU4LzB4Njg0DQo+ICAgIFsgMzQ1OC4x
OTI2OThdWyAgICBDNV0gIGFyY2hfdGltZXJfaGFuZGxlcl92aXJ0KzB4NWMvMHhhMA0KPiAg
ICBbIDM0NTguMTk4MDAyXVsgICAgQzVdICBoYW5kbGVfcGVyY3B1X2RldmlkX2lycSsweGRj
LzB4NDE0DQo+ICAgIFsgMzQ1OC4yMDMzODVdWyAgICBDNV0gIGhhbmRsZV9kb21haW5faXJx
KzB4YTgvMHgxNjgNCj4gICAgWyAzNDU4LjIwODI0MV1bICAgIEM1XSAgZ2ljX2hhbmRsZV9p
cnEuMzQ0OTMrMHg1NC8weDI0NA0KPiAgICBbIDM0NTguMjEzMzU5XVsgICAgQzVdICBjYWxs
X29uX2lycV9zdGFjaysweDQwLzB4NzANCj4gICAgWyAzNDU4LjIxODEyNV1bICAgIEM1XSAg
ZG9faW50ZXJydXB0X2hhbmRsZXIrMHg2MC8weDljDQo+ICAgIFsgMzQ1OC4yMjMxNTZdWyAg
ICBDNV0gIGVsMV9pbnRlcnJ1cHQrMHgzNC8weDY0DQo+ICAgIFsgMzQ1OC4yMjc1NjBdWyAg
ICBDNV0gIGVsMWhfNjRfaXJxX2hhbmRsZXIrMHgxYy8weDJjDQo+ICAgIFsgMzQ1OC4yMzI1
MDNdWyAgICBDNV0gIGVsMWhfNjRfaXJxKzB4N2MvMHg4MA0KPiAgICBbIDM0NTguMjM2NzM2
XVsgICAgQzVdICBmcmVlX3ZtYXBfYXJlYV9ub2ZsdXNoKzB4MTA4LzB4MzljDQo+ICAgIFsg
MzQ1OC4yNDIxMjZdWyAgICBDNV0gIHJlbW92ZV92bV9hcmVhKzB4YmMvMHgxMTgNCj4gICAg
WyAzNDU4LjI0NjcxNF1bICAgIEM1XSAgdm1fcmVtb3ZlX21hcHBpbmdzKzB4NDgvMHgyYTQN
Cj4gICAgWyAzNDU4LjI1MTY1Nl1bICAgIEM1XSAgX192dW5tYXArMHgxNTQvMHgyNzgNCj4g
ICAgWyAzNDU4LjI1NTc5Nl1bICAgIEM1XSAgc3RvbGVuX3RpbWVfY3B1X2Rvd25fcHJlcGFy
ZSsweGMwLzB4ZDgNCj4gICAgWyAzNDU4LjI2MTU0Ml1bICAgIEM1XSAgY3B1aHBfaW52b2tl
X2NhbGxiYWNrKzB4MjQ4LzB4YzM0DQo+ICAgIFsgMzQ1OC4yNjY4NDJdWyAgICBDNV0gIGNw
dWhwX3RocmVhZF9mdW4rMHgxYzQvMHgyNDgNCj4gICAgWyAzNDU4LjI3MTY5Nl1bICAgIEM1
XSAgc21wYm9vdF90aHJlYWRfZm4rMHgxYjAvMHg0MDANCj4gICAgWyAzNDU4LjI3NjYzOF1b
ICAgIEM1XSAga3RocmVhZCsweDE3Yy8weDFlMA0KPiAgICBbIDM0NTguMjgwNjkxXVsgICAg
QzVdICByZXRfZnJvbV9mb3JrKzB4MTAvMHgyMA0KPiANCj4gQXMgYSBmaXgsIGludHJvZHVj
ZSByY3UgbG9jayB0byB1cGRhdGUgc3RvbGVuIHRpbWUgc3RydWN0dXJlLg0KPiANCj4gRml4
ZXM6IDc1ZGY1MjliZWM5MSAoImFybTY0OiBwYXJhdmlydDogSW5pdGlhbGl6ZSBzdGVhbCB0
aW1lIHdoZW4gY3B1IGlzIG9ubGluZSIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQo+IFNpZ25lZC1vZmYtYnk6IFByYWtydXRoaSBEZWVwYWsgSGVyYWd1IDxxdWljX3BoZXJh
Z3VAcXVpY2luYy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEVsbGlvdCBCZXJtYW4gPHF1aWNf
ZWJlcm1hbkBxdWljaW5jLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpn
cm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2VuDQo=
--------------Lqc0Jx82gB2MJ5eOgbe3v0Ti
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------Lqc0Jx82gB2MJ5eOgbe3v0Ti--

--------------dRLRymBekbLvthqZxssmtJ0j--

--------------xuyclinqwvjtwpIMj7eZwjJz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmJygjkFAwAAAAAACgkQsN6d1ii/Ey8m
qQf+L/un+sZhNjTuRokZrpKwchtUInkitMKwf0t1vKDAvd597+9+gz2kmqPYmEKUr+iZrrPeoVyz
mc9gupMZ/AZhJeRhzMR+VySSUZBse4sUCrwSBb/6Q7wc/rWe+grJ8cnu1dEWeLPrK/Z6LAj1BJiA
y3T737cjFEXzC1s/TX/6ikD2X/gEXBPXPD7IzxnPNPS6RaSqg0lA1Ykl953HEdLDxRkBuFpUmf2b
F/ilAjhor6mpy36H5j3PXjPMfzYWWt4nY/ZsZyER8f/0WapOVLmcaPuPkbhLZWO5L9wRf7T/AXD/
58ZyUhzLLh/A7q19zrfRymmBOedGKEVeIHL/ShTDNw==
=DLvL
-----END PGP SIGNATURE-----

--------------xuyclinqwvjtwpIMj7eZwjJz--
