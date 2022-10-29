Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE621611F83
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 05:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJ2DAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiJ2DA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 23:00:29 -0400
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D116319E92A;
        Fri, 28 Oct 2022 19:58:40 -0700 (PDT)
Received: by mail-il1-f172.google.com with SMTP id g13so3896866ile.0;
        Fri, 28 Oct 2022 19:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gjKZuz9IffGjuGKpn3PW3u/OD19cZl3dQNkCioVIVE=;
        b=XKzswANHM5Ef8hqs9iQ4TsPao6yww1T5iM1YCzlKxfDRSo4kdP4ggXSQ9qlXHYgqu4
         rjYVNYbM6iItSU2ejrv4VIJmKv74PkvrJ2HuqHDXgqmAGWY0XEWsFxeVhdn0edic53mH
         RH3e098qjmQ8N8yINSr7JonzFXmJlQd1MpRe2/JuQXUEN37EcbnlD9wY/ObrCjF7zDzx
         kvQqR0MVFeacm5rHdwZhtfhu3NzW0NiyeuqrqiCZi3Jz6nUqPvWxay2TD2kYeGCBaEuE
         tviqNEuDlS9jPs+kptVe1RRDxvmarkZj+BJfDf4I/UOPnE5zk4Mzvw2ImuqusMagR4O6
         Ni1A==
X-Gm-Message-State: ACrzQf0Pgr5T36yi/b7/70SS1gGjeiLqUYqnEPxiW+JmaDgik2uwTUCL
        eoLOGkQFZWqkCcKUFHh7E4zfK9Wc7Q==
X-Google-Smtp-Source: AMsMyM6QzmKR5UibNbPWHomyr47E0m7ZOKfqeBwoXMcNRs/oBZHNhxbOHCQDC95A0WRMuV5OvUWcUA==
X-Received: by 2002:a05:6e02:19c9:b0:2fc:6475:510f with SMTP id r9-20020a056e0219c900b002fc6475510fmr1135728ill.44.1667012286677;
        Fri, 28 Oct 2022 19:58:06 -0700 (PDT)
Received: from [192.168.75.138] (50-36-85-28.alma.mi.frontiernet.net. [50.36.85.28])
        by smtp.gmail.com with ESMTPSA id bg3-20020a0566383c4300b00375217ea9b6sm163292jab.45.2022.10.28.19.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 19:58:06 -0700 (PDT)
Message-ID: <ed85737568bcecb5833130f10630c9fedbfa0336.camel@kernel.org>
Subject: Stable patch for 5.15.x
From:   Trond Myklebust <trondmy@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-nfs@vger.kernel.org,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Scott Mayhew <smayhew@redhat.com>
Date:   Fri, 28 Oct 2022 22:58:05 -0400
Content-Type: multipart/mixed; boundary="=-cj1xZxAySvRZYL7FqNNp"
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-cj1xZxAySvRZYL7FqNNp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg / Sasha,

Can we please pull commit c3ed222745d9 ("NFSv4: Fix free of
uninitialized nfs4_label on referral lookup.") into the 5.15.x tree? As
far as I can tell, it should apply cleanly on top of v5.15.75.

Unfortunately, that commit also contains a bug, which requires us to
pull in commit 4f40a5b55446 ("NFSv4: Add an fattr allocation to
_nfs4_discover_trunking()"), which does not apply cleanly. I've
attached a backported version to this email.

I'm seeing the Oops that this commit fixes when I do a NFSv4.2 mount
from a NFS client running a 5.15.75 kernel against a server that has
referrals configured. The reason is that commit d755ad8dc752 ("NFS:
Create a new nfs_alloc_fattr_with_label() function") got pulled into
v5.15.46 apparently as part of a dependency.

Thanks
 Trond

--=20
Trond Myklebust
Linux NFS client maintainer, Hammerspace
trond.myklebust@hammerspace.com



--=-cj1xZxAySvRZYL7FqNNp
Content-Disposition: inline; filename="0001-NFSv4-Add-an-fattr-allocation-to-_nfs4_discover_trun.patch"
Content-Type: text/x-patch; name="0001-NFSv4-Add-an-fattr-allocation-to-_nfs4_discover_trun.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA4MGI5NzljMWJlYzIxYTc2OTEzYzA1NmFiMGEwMjRlNDFlYWIwODU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTY290dCBNYXloZXcgPHNtYXloZXdAcmVkaGF0LmNvbT4KRGF0
ZTogTW9uLCAyNyBKdW4gMjAyMiAxNzozMToyOSAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIE5GU3Y0
OiBBZGQgYW4gZmF0dHIgYWxsb2NhdGlvbiB0byBfbmZzNF9kaXNjb3Zlcl90cnVua2luZygpCgpU
aGlzIHdhcyBtaXNzZWQgaW4gYzNlZDIyMjc0NWQ5ICgiTkZTdjQ6IEZpeCBmcmVlIG9mIHVuaW5p
dGlhbGl6ZWQKbmZzNF9sYWJlbCBvbiByZWZlcnJhbCBsb29rdXAuIikgYW5kIGNhdXNlcyBhIHBh
bmljIHdoZW4gbW91bnRpbmcKd2l0aCAnLW8gdHJ1bmtkaXNjb3ZlcnknOgoKUElEOiAxNjA0ICAg
VEFTSzogZmZmZjkzZGFjMzUyMDAwMCAgQ1BVOiAzICAgQ09NTUFORDogIm1vdW50Lm5mcyIKICMw
IFtmZmZmYjc5MTQwZjczOGY4XSBtYWNoaW5lX2tleGVjIGF0IGZmZmZmZmZmYWVjNjRiZWUKICMx
IFtmZmZmYjc5MTQwZjczOTUwXSBfX2NyYXNoX2tleGVjIGF0IGZmZmZmZmZmYWVkYTY3ZmQKICMy
IFtmZmZmYjc5MTQwZjczYTE4XSBjcmFzaF9rZXhlYyBhdCBmZmZmZmZmZmFlZGE3NmVkCiAjMyBb
ZmZmZmI3OTE0MGY3M2EzMF0gb29wc19lbmQgYXQgZmZmZmZmZmZhZWMyNjU4ZAogIzQgW2ZmZmZi
NzkxNDBmNzNhNTBdIGdlbmVyYWxfcHJvdGVjdGlvbiBhdCBmZmZmZmZmZmFmNjAxMTFlCiAgICBb
ZXhjZXB0aW9uIFJJUDogbmZzX2ZhdHRyX2luaXQrMHg1XQogICAgUklQOiBmZmZmZmZmZmMwYzE4
MjY1ICBSU1A6IGZmZmZiNzkxNDBmNzNiMDggIFJGTEFHUzogMDAwMTAyNDYKICAgIFJBWDogMDAw
MDAwMDAwMDAwMDAwMCAgUkJYOiBmZmZmOTNkYWMzMDRhODAwICBSQ1g6IDAwMDAwMDAwMDAwMDAw
MDAKICAgIFJEWDogZmZmZmI3OTE0MGY3M2JiMCAgUlNJOiBmZmZmOTNkYWRjOGNiYjQwICBSREk6
IGQwM2VlMTFjZmFmNmJkNTAKICAgIFJCUDogZmZmZmI3OTE0MGY3M2JlOCAgIFI4OiBmZmZmZmZm
ZmMwNjkxNTYwICAgUjk6IDAwMDAwMDAwMDAwMDAwMDYKICAgIFIxMDogZmZmZjkzZGIzZmZkM2Rm
OCAgUjExOiAwMDAwMDAwMDAwMDAwMDAwICBSMTI6IGZmZmY5M2RhYzQwNDAwMDAKICAgIFIxMzog
ZmZmZjkzZGFjMjg0OGUwMCAgUjE0OiBmZmZmYjc5MTQwZjczYjYwICBSMTU6IGZmZmZiNzkxNDBm
NzNiMzAKICAgIE9SSUdfUkFYOiBmZmZmZmZmZmZmZmZmZmZmICBDUzogMDAxMCAgU1M6IDAwMTgK
ICM1IFtmZmZmYjc5MTQwZjczYjA4XSBfbmZzNDFfcHJvY19nZXRfbG9jYXRpb25zIGF0IGZmZmZm
ZmZmYzBjNzNkNTMgW25mc3Y0XQogIzYgW2ZmZmZiNzkxNDBmNzNiZjBdIG5mczRfcHJvY19nZXRf
bG9jYXRpb25zIGF0IGZmZmZmZmZmYzBjODNlOTAgW25mc3Y0XQogIzcgW2ZmZmZiNzkxNDBmNzNj
NjBdIG5mczRfZGlzY292ZXJfdHJ1bmtpbmcgYXQgZmZmZmZmZmZjMGM4M2ZiNyBbbmZzdjRdCiAj
OCBbZmZmZmI3OTE0MGY3M2NkOF0gbmZzX3Byb2JlX2ZzaW5mbyBhdCBmZmZmZmZmZmMwYzBmOTVm
IFtuZnNdCiAjOSBbZmZmZmI3OTE0MGY3M2RhMF0gbmZzX3Byb2JlX3NlcnZlciBhdCBmZmZmZmZm
ZmMwYzEwMjZhIFtuZnNdCiAgICBSSVA6IDAwMDA3ZjYyNTRmY2UyNmUgIFJTUDogMDAwMDdmZmM2
OTQ5NmFjOCAgUkZMQUdTOiAwMDAwMDI0NgogICAgUkFYOiBmZmZmZmZmZmZmZmZmZmRhICBSQlg6
IDAwMDAwMDAwMDAwMDAwMDAgIFJDWDogMDAwMDdmNjI1NGZjZTI2ZQogICAgUkRYOiAwMDAwNTYw
MDIyMGE4MmEwICBSU0k6IDAwMDA1NjAwMjIwYTY0ZDAgIFJESTogMDAwMDU2MDAyMjBhNjUyMAog
ICAgUkJQOiAwMDAwN2ZmYzY5NDk2YzUwICAgUjg6IDAwMDA1NjAwMjIwYTg3MTAgICBSOTogMDAz
MDM1MzIyZTMyMzIzMQogICAgUjEwOiAwMDAwMDAwMDAwMDAwMDAwICBSMTE6IDAwMDAwMDAwMDAw
MDAyNDYgIFIxMjogMDAwMDdmZmM2OTQ5NmM1MAogICAgUjEzOiAwMDAwNTYwMDIyMGE4NDQwICBS
MTQ6IDAwMDAwMDAwMDAwMDAwMTAgIFIxNTogMDAwMDU2MDAyMDY1MGVmOQogICAgT1JJR19SQVg6
IDAwMDAwMDAwMDAwMDAwYTUgIENTOiAwMDMzICBTUzogMDAyYgoKRml4ZXM6IGMzZWQyMjI3NDVk
OSAoIk5GU3Y0OiBGaXggZnJlZSBvZiB1bmluaXRpYWxpemVkIG5mczRfbGFiZWwgb24gcmVmZXJy
YWwgbG9va3VwLiIpClNpZ25lZC1vZmYtYnk6IFNjb3R0IE1heWhldyA8c21heWhld0ByZWRoYXQu
Y29tPgpTaWduZWQtb2ZmLWJ5OiBBbm5hIFNjaHVtYWtlciA8QW5uYS5TY2h1bWFrZXJATmV0YXBw
LmNvbT4KKGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgNGY0MGE1YjU1NDQ2MThiMDk2ZDE2MTFh
MTgyMTlkZDkxZmQ1N2Y4MCkKU2lnbmVkLW9mZi1ieTogVHJvbmQgTXlrbGVidXN0IDx0cm9uZC5t
eWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tPgotLS0KIGZzL25mcy9uZnM0cHJvYy5jIHwgMTkgKysr
KysrKysrKysrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDcgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvbmZzL25mczRwcm9jLmMgYi9mcy9uZnMvbmZzNHBy
b2MuYwppbmRleCBjODZlZmQzNmRlYTguLmI0MmUzMzI3NzVmZSAxMDA2NDQKLS0tIGEvZnMvbmZz
L25mczRwcm9jLmMKKysrIGIvZnMvbmZzL25mczRwcm9jLmMKQEAgLTM5ODEsMTggKzM5ODEsMjMg
QEAgc3RhdGljIGludCBfbmZzNF9kaXNjb3Zlcl90cnVua2luZyhzdHJ1Y3QgbmZzX3NlcnZlciAq
c2VydmVyLAogCX0KIAogCXBhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOworCWlmICghcGFn
ZSkKKwkJcmV0dXJuIC1FTk9NRU07CiAJbG9jYXRpb25zID0ga21hbGxvYyhzaXplb2Yoc3RydWN0
IG5mczRfZnNfbG9jYXRpb25zKSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKHBhZ2UgPT0gTlVMTCB8fCBs
b2NhdGlvbnMgPT0gTlVMTCkKLQkJZ290byBvdXQ7CisJaWYgKCFsb2NhdGlvbnMpCisJCWdvdG8g
b3V0X2ZyZWU7CisJbG9jYXRpb25zLT5mYXR0ciA9IG5mc19hbGxvY19mYXR0cigpOworCWlmICgh
bG9jYXRpb25zLT5mYXR0cikKKwkJZ290byBvdXRfZnJlZV8yOwogCiAJc3RhdHVzID0gbmZzNF9w
cm9jX2dldF9sb2NhdGlvbnMoc2VydmVyLCBmaGFuZGxlLCBsb2NhdGlvbnMsIHBhZ2UsCiAJCQkJ
CSBjcmVkKTsKLQlpZiAoc3RhdHVzKQotCQlnb3RvIG91dDsKLW91dDoKLQlpZiAocGFnZSkKLQkJ
X19mcmVlX3BhZ2UocGFnZSk7CisKKwlrZnJlZShsb2NhdGlvbnMtPmZhdHRyKTsKK291dF9mcmVl
XzI6CiAJa2ZyZWUobG9jYXRpb25zKTsKK291dF9mcmVlOgorCV9fZnJlZV9wYWdlKHBhZ2UpOwog
CXJldHVybiBzdGF0dXM7CiB9CiAKLS0gCjIuMzcuMwoK



--=-cj1xZxAySvRZYL7FqNNp--
