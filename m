Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F36F64CED2
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 18:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiLNRWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 12:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238887AbiLNRWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 12:22:03 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB5DC759
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:22:02 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id f189so371439vsc.11
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RENnBFKNq16wzpVPwOS1YmTousOMeigLolFy45SL4nc=;
        b=ePiDDtRedQJUOXDZIkKe7vDosaZdNWCUaMfLcvkYLqDHRsPNbyRt6R3a1VwzKH+JID
         wZYh3fdyAWLptUNnhBVV9MgAz5bW/PW8IiOVCg9AmvQna8N0+oo0+RzhlWj947a7AxKv
         yxu2x1A/gIJ4tylCGzl41bGDXsOJ3HFwWsalYqBj5yBIwXTLd8nc6wsefGdeS6MJq8sa
         q07zZmYAzamRxeBMhbesGqLdFjI5Z1cOMfQVBbdHJVWeM9WLw+MYveovswtn6QclK4pn
         KZjNWRC5VY7leLBOozCG+S9BWH2iWg2RnJpp8AfDzbl0q9reEXLEA6mKNJi0Adfjporz
         dZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RENnBFKNq16wzpVPwOS1YmTousOMeigLolFy45SL4nc=;
        b=xBrPzTlcrLV7pvoPpzE7693mV5Cad1rAFqBShuaOulbEoCOvi0+C5cQGeLN7F5/zxp
         GjfxRcC+aatWNYFdy55oVQoo3T8wxvo0TnpoSysgqB0W3Jl3ahZhlDfLPFZZu4TVcyJe
         yBjaoeY6OPT6uKPdZvovlz1AE2TtB2FG/nmCAXFw+zuvPqum+ZLmKkW41+SXjAHoaaaZ
         gKcouwbbPPpUCd0eacOmlrDl16iQCS+4ePH+407jWj0d2yVrSO/KVAbgpYllJwo40VXw
         JoXrlC2XAy0da2pHiAZm+aMYcUEEkWQmOteI+QL49+XJAHPThUGPr8mgIebt40xuN/yR
         ymcg==
X-Gm-Message-State: ANoB5pnWDqxgYyiiIYItqpcigBrX0YcEuxXrKzAXyHiLCA9db2zeE9KW
        cORlfND2c/5TAE6JN4/KSre/XqrypPwFFGNO/W1/EVmopFs=
X-Google-Smtp-Source: AA0mqf7G0v47GF9739IIeOktrLGtCpie/rOY/EhnrIq5UANQHFt0ezZ83v8BN01yaGdvIpzdo1GX/rwu2l/7Y3uAbCk=
X-Received: by 2002:a05:6102:c8c:b0:3b0:9171:95f7 with SMTP id
 f12-20020a0561020c8c00b003b0917195f7mr33448337vst.3.1671038520623; Wed, 14
 Dec 2022 09:22:00 -0800 (PST)
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org> <20221205190809.690922836@linuxfoundation.org>
 <CAOQ4uxhmZ4RnG0mGaMivyQjS43cUykyO-oVtCLX4AFyrnTXrVA@mail.gmail.com> <Y5nys0X8X9havZ4G@kroah.com>
In-Reply-To: <Y5nys0X8X9havZ4G@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 14 Dec 2022 19:21:47 +0200
Message-ID: <CAOQ4uxj+1PnATa3xQN_gGkiMBS-m7BfX6-qHRe_7hEjD43c+LA@mail.gmail.com>
Subject: Re: [PATCH 6.0 044/124] vfs: fix copy_file_range() averts filesystem
 freeze protection
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Namjae Jeon <linkinjeon@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006d9b1805efccf9bc"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000006d9b1805efccf9bc
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 14, 2022 at 5:58 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 13, 2022 at 10:03:02AM +0200, Amir Goldstein wrote:
> > On Mon, Dec 5, 2022 at 9:24 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Amir Goldstein <amir73il@gmail.com>
> > >
> > > [ Upstream commit 10bc8e4af65946b727728d7479c028742321b60a ]
> > >
> > > Commit 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs
> > > copies") removed fallback to generic_copy_file_range() for cross-fs
> > > cases inside vfs_copy_file_range().
> >
> > Hi Greg,
> >
> > The regressing commit is in v5.15.53.
> > Please apply this fix to 5.15.y.
>
> This commit does not apply to 5.15.y as-is (breaks the build),

Sorry. compiled without lockdep.

> can you provide a working backport?
>

Patch attached with lockdep assert removed.

Thanks,
Amir.

--0000000000006d9b1805efccf9bc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="stable-5.15-vfs-fix-copy_file_range-averts-filesystem-freeze.patch"
Content-Disposition: attachment; 
	filename="stable-5.15-vfs-fix-copy_file_range-averts-filesystem-freeze.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lbnx3mk80>
X-Attachment-Id: f_lbnx3mk80

RnJvbSBiOGI3MWJlMTNhNjM4N2MxZjRhYWE1NzYwYTlhMDJjYmYxNWFmMWQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDE3IE5vdiAyMDIyIDIyOjUyOjQ5ICswMjAwClN1YmplY3Q6IFtQQVRDSCA1LjE1
XSB2ZnM6IGZpeCBjb3B5X2ZpbGVfcmFuZ2UoKSBhdmVydHMgZmlsZXN5c3RlbSBmcmVlemUKIHBy
b3RlY3Rpb24KCmNvbW1pdCAxMGJjOGU0YWY2NTk0NmI3Mjc3MjhkNzQ3OWMwMjg3NDIzMjFiNjBh
IHVwc3RyZWFtLgoKW2JhY2twb3J0IGNvbW1lbnRzIGZvciB2NS4xNToKLSBzYl93cml0ZV9zdGFy
dGVkKCkgaXMgbWlzc2luZyAtIGFzc2VydCB3YXMgZHJvcHBlZApdCgpDb21taXQgODY4ZjlmMmY4
ZTAwICgidmZzOiBmaXggY29weV9maWxlX3JhbmdlKCkgcmVncmVzc2lvbiBpbiBjcm9zcy1mcwpj
b3BpZXMiKSByZW1vdmVkIGZhbGxiYWNrIHRvIGdlbmVyaWNfY29weV9maWxlX3JhbmdlKCkgZm9y
IGNyb3NzLWZzCmNhc2VzIGluc2lkZSB2ZnNfY29weV9maWxlX3JhbmdlKCkuCgpUbyBwcmVzZXJ2
ZSBiZWhhdmlvciBvZiBuZnNkIGFuZCBrc21iZCBzZXJ2ZXItc2lkZS1jb3B5LCB0aGUgZmFsbGJh
Y2sgdG8KZ2VuZXJpY19jb3B5X2ZpbGVfcmFuZ2UoKSB3YXMgYWRkZWQgaW4gbmZzZCBhbmQga3Nt
YmQgY29kZSwgYnV0IHRoYXQKY2FsbCBpcyBtaXNzaW5nIHNiX3N0YXJ0X3dyaXRlKCksIGZzbm90
aWZ5IGhvb2tzIGFuZCBtb3JlLgoKSWRlYWxseSwgbmZzZCBhbmQga3NtYmQgd291bGQgcGFzcyBh
IGZsYWcgdG8gdmZzX2NvcHlfZmlsZV9yYW5nZSgpIHRoYXQKd2lsbCB0YWtlIGNhcmUgb2YgdGhl
IGZhbGxiYWNrLCBidXQgdGhhdCBjb2RlIHdvdWxkIGJlIHN1YnRsZSBhbmQgd2UgZ290CnZmc19j
b3B5X2ZpbGVfcmFuZ2UoKSBsb2dpYyB3cm9uZyB0b28gbWFueSB0aW1lcyBhbHJlYWR5LgoKSW5z
dGVhZCwgYWRkIGEgZmxhZyB0byBleHBsaWNpdGx5IHJlcXVlc3QgdmZzX2NvcHlfZmlsZV9yYW5n
ZSgpIHRvCnBlcmZvcm0gb25seSBnZW5lcmljX2NvcHlfZmlsZV9yYW5nZSgpIGFuZCBsZXQgbmZz
ZCBhbmQga3NtYmQgdXNlIHRoaXMKZmxhZyBvbmx5IGluIHRoZSBmYWxsYmFjayBwYXRoLgoKVGhp
cyBjaG9pc2Uga2VlcHMgdGhlIGxvZ2ljIGNoYW5nZXMgdG8gbWluaW11bSBpbiB0aGUgbm9uLW5m
c2Qva3NtYmQgY29kZQpwYXRocyB0byByZWR1Y2UgdGhlIHJpc2sgb2YgZnVydGhlciByZWdyZXNz
aW9ucy4KCkZpeGVzOiA4NjhmOWYyZjhlMDAgKCJ2ZnM6IGZpeCBjb3B5X2ZpbGVfcmFuZ2UoKSBy
ZWdyZXNzaW9uIGluIGNyb3NzLWZzIGNvcGllcyIpClRlc3RlZC1ieTogTmFtamFlIEplb24gPGxp
bmtpbmplb25Aa2VybmVsLm9yZz4KVGVzdGVkLWJ5OiBMdWlzIEhlbnJpcXVlcyA8bGhlbnJpcXVl
c0BzdXNlLmRlPgpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwu
Y29tPgpTaWduZWQtb2ZmLWJ5OiBBbCBWaXJvIDx2aXJvQHplbml2LmxpbnV4Lm9yZy51az4KU2ln
bmVkLW9mZi1ieTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KLS0tCiBmcy9r
c21iZC92ZnMuYyAgICAgfCAgNiArKystLS0KIGZzL25mc2QvdmZzLmMgICAgICB8ICA0ICsrLS0K
IGZzL3JlYWRfd3JpdGUuYyAgICB8IDE3ICsrKysrKysrKysrKystLS0tCiBpbmNsdWRlL2xpbnV4
L2ZzLmggfCAgOCArKysrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCA5
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL3Zmcy5jIGIvZnMva3NtYmQvdmZz
LmMKaW5kZXggNTEzOTg5YjFjOGNkLi41ZDQwYTAwZmJjZTUgMTAwNjQ0Ci0tLSBhL2ZzL2tzbWJk
L3Zmcy5jCisrKyBiL2ZzL2tzbWJkL3Zmcy5jCkBAIC0xNzg4LDkgKzE3ODgsOSBAQCBpbnQga3Nt
YmRfdmZzX2NvcHlfZmlsZV9yYW5nZXMoc3RydWN0IGtzbWJkX3dvcmsgKndvcmssCiAJCXJldCA9
IHZmc19jb3B5X2ZpbGVfcmFuZ2Uoc3JjX2ZwLT5maWxwLCBzcmNfb2ZmLAogCQkJCQkgIGRzdF9m
cC0+ZmlscCwgZHN0X29mZiwgbGVuLCAwKTsKIAkJaWYgKHJldCA9PSAtRU9QTk9UU1VQUCB8fCBy
ZXQgPT0gLUVYREVWKQotCQkJcmV0ID0gZ2VuZXJpY19jb3B5X2ZpbGVfcmFuZ2Uoc3JjX2ZwLT5m
aWxwLCBzcmNfb2ZmLAotCQkJCQkJICAgICAgZHN0X2ZwLT5maWxwLCBkc3Rfb2ZmLAotCQkJCQkJ
ICAgICAgbGVuLCAwKTsKKwkJCXJldCA9IHZmc19jb3B5X2ZpbGVfcmFuZ2Uoc3JjX2ZwLT5maWxw
LCBzcmNfb2ZmLAorCQkJCQkJICBkc3RfZnAtPmZpbHAsIGRzdF9vZmYsIGxlbiwKKwkJCQkJCSAg
Q09QWV9GSUxFX1NQTElDRSk7CiAJCWlmIChyZXQgPCAwKQogCQkJcmV0dXJuIHJldDsKIApkaWZm
IC0tZ2l0IGEvZnMvbmZzZC92ZnMuYyBiL2ZzL25mc2QvdmZzLmMKaW5kZXggYWJmYmI2OTUzZTg5
Li5kNGFkYzU5OTczN2QgMTAwNjQ0Ci0tLSBhL2ZzL25mc2QvdmZzLmMKKysrIGIvZnMvbmZzZC92
ZnMuYwpAQCAtNTc0LDggKzU3NCw4IEBAIHNzaXplX3QgbmZzZF9jb3B5X2ZpbGVfcmFuZ2Uoc3Ry
dWN0IGZpbGUgKnNyYywgdTY0IHNyY19wb3MsIHN0cnVjdCBmaWxlICpkc3QsCiAJcmV0ID0gdmZz
X2NvcHlfZmlsZV9yYW5nZShzcmMsIHNyY19wb3MsIGRzdCwgZHN0X3BvcywgY291bnQsIDApOwog
CiAJaWYgKHJldCA9PSAtRU9QTk9UU1VQUCB8fCByZXQgPT0gLUVYREVWKQotCQlyZXQgPSBnZW5l
cmljX2NvcHlfZmlsZV9yYW5nZShzcmMsIHNyY19wb3MsIGRzdCwgZHN0X3BvcywKLQkJCQkJICAg
ICAgY291bnQsIDApOworCQlyZXQgPSB2ZnNfY29weV9maWxlX3JhbmdlKHNyYywgc3JjX3Bvcywg
ZHN0LCBkc3RfcG9zLCBjb3VudCwKKwkJCQkJICBDT1BZX0ZJTEVfU1BMSUNFKTsKIAlyZXR1cm4g
cmV0OwogfQogCmRpZmYgLS1naXQgYS9mcy9yZWFkX3dyaXRlLmMgYi9mcy9yZWFkX3dyaXRlLmMK
aW5kZXggOGQzZWM5NzU1MTRkLi5iNGIxNTI3OWI2NmIgMTAwNjQ0Ci0tLSBhL2ZzL3JlYWRfd3Jp
dGUuYworKysgYi9mcy9yZWFkX3dyaXRlLmMKQEAgLTE0MTgsNyArMTQxOCw5IEBAIHN0YXRpYyBp
bnQgZ2VuZXJpY19jb3B5X2ZpbGVfY2hlY2tzKHN0cnVjdCBmaWxlICpmaWxlX2luLCBsb2ZmX3Qg
cG9zX2luLAogCSAqIGFuZCBzZXZlcmFsIGRpZmZlcmVudCBzZXRzIG9mIGZpbGVfb3BlcmF0aW9u
cywgYnV0IHRoZXkgYWxsIGVuZCB1cAogCSAqIHVzaW5nIHRoZSBzYW1lIC0+Y29weV9maWxlX3Jh
bmdlKCkgZnVuY3Rpb24gcG9pbnRlci4KIAkgKi8KLQlpZiAoZmlsZV9vdXQtPmZfb3AtPmNvcHlf
ZmlsZV9yYW5nZSkgeworCWlmIChmbGFncyAmIENPUFlfRklMRV9TUExJQ0UpIHsKKwkJLyogY3Jv
c3Mgc2Igc3BsaWNlIGlzIGFsbG93ZWQgKi8KKwl9IGVsc2UgaWYgKGZpbGVfb3V0LT5mX29wLT5j
b3B5X2ZpbGVfcmFuZ2UpIHsKIAkJaWYgKGZpbGVfaW4tPmZfb3AtPmNvcHlfZmlsZV9yYW5nZSAh
PQogCQkgICAgZmlsZV9vdXQtPmZfb3AtPmNvcHlfZmlsZV9yYW5nZSkKIAkJCXJldHVybiAtRVhE
RVY7CkBAIC0xNDY4LDggKzE0NzAsOSBAQCBzc2l6ZV90IHZmc19jb3B5X2ZpbGVfcmFuZ2Uoc3Ry
dWN0IGZpbGUgKmZpbGVfaW4sIGxvZmZfdCBwb3NfaW4sCiAJCQkgICAgc2l6ZV90IGxlbiwgdW5z
aWduZWQgaW50IGZsYWdzKQogewogCXNzaXplX3QgcmV0OworCWJvb2wgc3BsaWNlID0gZmxhZ3Mg
JiBDT1BZX0ZJTEVfU1BMSUNFOwogCi0JaWYgKGZsYWdzICE9IDApCisJaWYgKGZsYWdzICYgfkNP
UFlfRklMRV9TUExJQ0UpCiAJCXJldHVybiAtRUlOVkFMOwogCiAJcmV0ID0gZ2VuZXJpY19jb3B5
X2ZpbGVfY2hlY2tzKGZpbGVfaW4sIHBvc19pbiwgZmlsZV9vdXQsIHBvc19vdXQsICZsZW4sCkBA
IC0xNDk1LDE0ICsxNDk4LDE0IEBAIHNzaXplX3QgdmZzX2NvcHlfZmlsZV9yYW5nZShzdHJ1Y3Qg
ZmlsZSAqZmlsZV9pbiwgbG9mZl90IHBvc19pbiwKIAkgKiBzYW1lIHNiIHVzaW5nIGNsb25lLCBi
dXQgZm9yIGZpbGVzeXN0ZW1zIHdoZXJlIGJvdGggY2xvbmUgYW5kIGNvcHkKIAkgKiBhcmUgc3Vw
cG9ydGVkIChlLmcuIG5mcyxjaWZzKSwgd2Ugb25seSBjYWxsIHRoZSBjb3B5IG1ldGhvZC4KIAkg
Ki8KLQlpZiAoZmlsZV9vdXQtPmZfb3AtPmNvcHlfZmlsZV9yYW5nZSkgeworCWlmICghc3BsaWNl
ICYmIGZpbGVfb3V0LT5mX29wLT5jb3B5X2ZpbGVfcmFuZ2UpIHsKIAkJcmV0ID0gZmlsZV9vdXQt
PmZfb3AtPmNvcHlfZmlsZV9yYW5nZShmaWxlX2luLCBwb3NfaW4sCiAJCQkJCQkgICAgICBmaWxl
X291dCwgcG9zX291dCwKIAkJCQkJCSAgICAgIGxlbiwgZmxhZ3MpOwogCQlnb3RvIGRvbmU7CiAJ
fQogCi0JaWYgKGZpbGVfaW4tPmZfb3AtPnJlbWFwX2ZpbGVfcmFuZ2UgJiYKKwlpZiAoIXNwbGlj
ZSAmJiBmaWxlX2luLT5mX29wLT5yZW1hcF9maWxlX3JhbmdlICYmCiAJICAgIGZpbGVfaW5vZGUo
ZmlsZV9pbiktPmlfc2IgPT0gZmlsZV9pbm9kZShmaWxlX291dCktPmlfc2IpIHsKIAkJcmV0ID0g
ZmlsZV9pbi0+Zl9vcC0+cmVtYXBfZmlsZV9yYW5nZShmaWxlX2luLCBwb3NfaW4sCiAJCQkJZmls
ZV9vdXQsIHBvc19vdXQsCkBAIC0xNTIyLDYgKzE1MjUsOCBAQCBzc2l6ZV90IHZmc19jb3B5X2Zp
bGVfcmFuZ2Uoc3RydWN0IGZpbGUgKmZpbGVfaW4sIGxvZmZfdCBwb3NfaW4sCiAJICogY29uc2lz
dGVudCBzdG9yeSBhYm91dCB3aGljaCBmaWxlc3lzdGVtcyBzdXBwb3J0IGNvcHlfZmlsZV9yYW5n
ZSgpCiAJICogYW5kIHdoaWNoIGZpbGVzeXN0ZW1zIGRvIG5vdCwgdGhhdCB3aWxsIGFsbG93IHVz
ZXJzcGFjZSB0b29scyB0bwogCSAqIG1ha2UgY29uc2lzdGVudCBkZXNpY2lvbnMgdy5yLnQgdXNp
bmcgY29weV9maWxlX3JhbmdlKCkuCisJICoKKwkgKiBXZSBhbHNvIGdldCBoZXJlIGlmIGNhbGxl
ciAoZS5nLiBuZnNkKSByZXF1ZXN0ZWQgQ09QWV9GSUxFX1NQTElDRS4KIAkgKi8KIAlyZXQgPSBn
ZW5lcmljX2NvcHlfZmlsZV9yYW5nZShmaWxlX2luLCBwb3NfaW4sIGZpbGVfb3V0LCBwb3Nfb3V0
LCBsZW4sCiAJCQkJICAgICAgZmxhZ3MpOwpAQCAtMTU3Niw2ICsxNTgxLDEwIEBAIFNZU0NBTExf
REVGSU5FNihjb3B5X2ZpbGVfcmFuZ2UsIGludCwgZmRfaW4sIGxvZmZfdCBfX3VzZXIgKiwgb2Zm
X2luLAogCQlwb3Nfb3V0ID0gZl9vdXQuZmlsZS0+Zl9wb3M7CiAJfQogCisJcmV0ID0gLUVJTlZB
TDsKKwlpZiAoZmxhZ3MgIT0gMCkKKwkJZ290byBvdXQ7CisKIAlyZXQgPSB2ZnNfY29weV9maWxl
X3JhbmdlKGZfaW4uZmlsZSwgcG9zX2luLCBmX291dC5maWxlLCBwb3Nfb3V0LCBsZW4sCiAJCQkJ
ICBmbGFncyk7CiAJaWYgKHJldCA+IDApIHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZnMu
aCBiL2luY2x1ZGUvbGludXgvZnMuaAppbmRleCA4MDZhYzcyYzcyMjAuLmQ1NWZkYzAyZjgyZCAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9mcy5oCisrKyBiL2luY2x1ZGUvbGludXgvZnMuaApA
QCAtMTk5MCw2ICsxOTkwLDE0IEBAIHN0cnVjdCBkaXJfY29udGV4dCB7CiAgKi8KICNkZWZpbmUg
UkVNQVBfRklMRV9BRFZJU09SWQkJKFJFTUFQX0ZJTEVfQ0FOX1NIT1JURU4pCiAKKy8qCisgKiBU
aGVzZSBmbGFncyBjb250cm9sIHRoZSBiZWhhdmlvciBvZiB2ZnNfY29weV9maWxlX3JhbmdlKCku
CisgKiBUaGV5IGFyZSBub3QgYXZhaWxhYmxlIHRvIHRoZSB1c2VyIHZpYSBzeXNjYWxsLgorICoK
KyAqIENPUFlfRklMRV9TUExJQ0U6IGNhbGwgc3BsaWNlIGRpcmVjdCBpbnN0ZWFkIG9mIGZzIGNs
b25lL2NvcHkgb3BzCisgKi8KKyNkZWZpbmUgQ09QWV9GSUxFX1NQTElDRQkJKDEgPDwgMCkKKwog
c3RydWN0IGlvdl9pdGVyOwogCiBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHsKLS0gCjIuMTYuNQoK
--0000000000006d9b1805efccf9bc--
