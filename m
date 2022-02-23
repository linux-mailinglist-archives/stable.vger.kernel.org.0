Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F394C14CB
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 14:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbiBWNzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 08:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiBWNzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 08:55:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22170B0A65;
        Wed, 23 Feb 2022 05:54:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BE5F621155;
        Wed, 23 Feb 2022 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645624483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=BDDtMFSlNaRroadtmjh5Rpea2LPkFe//rdeeAscwciI=;
        b=1hG1h0oScQB5MQ5JpmLkarELJg9Sd+dGOSWF9Sx/uh3llAxMIDnb4K2uM8fkw4yOUU/zwm
        Na0iR8+Mx5Q4UAJCX2wi4hCGpmu0EvBT8IwdUTgY8kmVNM2JjqBVpE3cUixDIFBoEuOhfH
        joUBQVQJi+MmhJCRQEmG2S6P531LddM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645624483;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=BDDtMFSlNaRroadtmjh5Rpea2LPkFe//rdeeAscwciI=;
        b=Ls2d1Dv6wKxOqma4CFw+uqyp1dbt4ahwDfB7wifMeJu6wkPAFpyUIaXLvGZVElJ/1/91+u
        dMitCnBiPMsvGNDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8FB4E13D72;
        Wed, 23 Feb 2022 13:54:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gELmIaM8FmIwOAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 23 Feb 2022 13:54:43 +0000
Content-Type: multipart/mixed; boundary="------------GrTvbgEqrrcmnHjnYyoN6t08"
Message-ID: <df3b5d1c-a36b-2c73-3e27-99e74983de3a@suse.cz>
Date:   Wed, 23 Feb 2022 14:54:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, patches@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: read() data corruption with CONFIG_READ_ONLY_THP_FOR_FS=y
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------GrTvbgEqrrcmnHjnYyoN6t08
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

we have found a bug involving CONFIG_READ_ONLY_THP_FOR_FS=y, introduced in
5.12 by cbd59c48ae2b ("mm/filemap: use head pages in
generic_file_buffered_read")
and apparently fixed in 5.17-rc1 by 6b24ca4a1a8d ("mm: Use multi-index
entries in the page cache")
The latter commit is part of folio rework so likely not stable material, so
it would be nice to have a small fix for e.g. 5.15 LTS. Preferably from
someone who understands xarray :)

The bug was found while building nodejs16, which involves running some
tests, first with a non-stripped node16 binary, and then stripping it. This
has a good chance of the stripped result becoming corrupted and not
executable anymore due to dynamic loader failures. It turns out that while
executed during tests, CONFIG_READ_ONLY_THP_FOR_FS=y allows khugepaged to
collapse the large executable mappings. Then /usr/bin/strip uses read() to
process the binary and triggers a bug introduced in cbd59c48ae2b where if a
read spans two or more collapsed THPs in the page cache, the first one will
be read multiple times instead.

Takashi Iwai has bisected using the nodejs build scenario to commit
cbd59c48ae2b.

I have distilled the scenario to the attached reproducer. There are some
assumptions for it to work:

- the passed path for file it creates/works with should be on a filesystem
such as xfs or ext4 that uses generic_file_buffered_read()
- the kernel should have e6be37b2e7bd ("mm/huge_memory.c: add missing
read-only THP checking in transparent_hugepage_enabled()") otherwise
khugepaged will not recognize the reproducer's mm as thp eligible (it had to
be some other mapping in nodejs that made it still possible to trigger this
during bisect)
- there's a pause to allow khugepaged to do its job, you can increase the
speed as instructed and verify with /proc/pid/smaps and meminfo that the
collapse in page cache has happened
- if the bug is reproduced, the reproducer will complain like this:
mismatch at offset 2097152: read value expected for offset 0 instead of 2097152

I've hacked some printk on top 5.16 (attached debug.patch)
which gives this output:

i=0 page=ffffea0004340000 page_offset=0 uoff=0 bytes=2097152
i=1 page=ffffea0004340000 page_offset=0 uoff=0 bytes=2097152
i=2 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
i=3 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
i=4 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
i=5 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
i=6 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
i=7 page=ffffea0004340000 page_offset=0 uoff=0 bytes=0
i=8 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
i=9 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
i=10 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
i=11 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
i=12 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
i=13 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0
i=14 page=ffffea0004470000 page_offset=2097152 uoff=0 bytes=0

It seems filemap_get_read_batch() should be returning pages ffffea0004340000
and ffffea0004470000 consecutively in the pvec, but returns the first one 8
times, so it's read twice and then the rest is just skipped over as it's
beyond the requested read size.

I suspect these lines:
  xas.xa_index = head->index + thp_nr_pages(head) - 1;
  xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;

commit 6b24ca4a1a8d changes those to xas_advance() (introduced one patch
earlier), so some self-contained fix should be possible for prior kernels?
But I don't understand xarray well enough.

My colleagues should be credited for initial analysis of the nodejs build
scenario:

Analyzed-by: Adam Majer <amajer@suse.com>
Analyzed-by: Dirk Mueller <dmueller@suse.com>
Bisected-by: Takashi Iwai <tiwai@suse.de>

Thanks,
Vlastimil
--------------GrTvbgEqrrcmnHjnYyoN6t08
Content-Type: text/x-csrc; charset=UTF-8; name="thp_reproducer.c"
Content-Disposition: attachment; filename="thp_reproducer.c"
Content-Transfer-Encoding: base64

CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3Rk
aW8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVk
ZSA8c3lzL3BhcmFtLmg+CgojZGVmaW5lIFBBR0VfU0laRQkoNDA5NikKI2RlZmluZSBQTURf
U0laRQkoUEFHRV9TSVpFICogNTEyKQojZGVmaW5lIFVMT05HX1NJWkUJKHNpemVvZih1bnNp
Z25lZCBsb25nKSkKI2RlZmluZSBVTE9OR1NfUEVSX1BBR0UJKChQQUdFX1NJWkUpIC8gKFVM
T05HX1NJWkUpKQojZGVmaW5lIE1BR0lDX1ZBTFVFCTB4YWJjZAoKCmludCB3cml0ZV9maWxl
KGNoYXIgKm5hbWUsIHVuc2lnbmVkIGxvbmcgc2l6ZSkKewoJdW5zaWduZWQgbG9uZyAqYnVm
OwoJdW5zaWduZWQgbG9uZyBpLCBwOwoJaW50IGZkOwoJaW50IHJldDsKCglidWYgPSBtbWFw
KE5VTEwsIFBBR0VfU0laRSwgUFJPVF9SRUFEfFBST1RfV1JJVEUsCgkJCU1BUF9QUklWQVRF
fE1BUF9BTk9OWU1PVVMsIDAsIDApOwoKCWlmIChidWYgPT0gTUFQX0ZBSUxFRCkgewoJCXBy
aW50ZigibW1hcCBmYWlsZWRcbiIpOwoJCWV4aXQoMSk7Cgl9CgoJZmQgPSBjcmVhdChuYW1l
LCBTX0lSV1hVKTsKCWlmIChmZCA9PSAtMSkgewoJCXBlcnJvcigiY3JlYXQiKTsKCQlleGl0
KDEpOwoJfQoKCWZvciAoaSA9IDA7IGkgPCBzaXplIC8gUEFHRV9TSVpFOyBpKyspIHsKCQli
dWZbMF0gPSBNQUdJQ19WQUxVRSArIGk7CgkJcmV0ID0gd3JpdGUoZmQsIGJ1ZiwgUEFHRV9T
SVpFKTsKCQkJLy8geWVhaCwgc2xvcHB5CgkJaWYgKHJldCAhPSBQQUdFX1NJWkUpIHsKCQkJ
cGVycm9yKCJ3cml0ZSIpOwoJCQlleGl0KDEpOwoJCX0KCX0KCgljbG9zZShmZCk7CgltdW5t
YXAoYnVmLCBQQUdFX1NJWkUpOwp9Cgp2b2lkIHRvdWNoKGNoYXIgKiBidWYsIHVuc2lnbmVk
IGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgc2l6ZSkKewoJdm9sYXRpbGUgY2hhciBmb287
CgoJZm9yIChjaGFyICogcHRyID0gYnVmICsgc3RhcnQ7CgkgICAgIHB0ciA8IGJ1ZiArIHN0
YXJ0ICsgc2l6ZTsKCSAgICAgcHRyICs9IFBBR0VfU0laRSkgewoJCWZvbyA9ICpwdHI7Cgl9
Cn0KCnZvaWQgdGVzdF9yZWFkKGludCBmZCwgb2ZmX3Qgb2ZmLCBzaXplX3QgY291bnQsIHNp
emVfdCBidWZzaXplKQp7CgljaGFyICpidWYgPSBOVUxMOwoJaW50IHJldDsKCglidWYgPSBt
bWFwKE5VTEwsIGJ1ZnNpemUsIFBST1RfUkVBRHxQUk9UX1dSSVRFLAoJCQlNQVBfQU5PTllN
T1VTfE1BUF9QUklWQVRFLCAwLCAwKTsKCWlmIChidWYgPT0gTUFQX0ZBSUxFRCkgewoJCXBl
cnJvcigibW1hcCIpOwoJCWV4aXQoMSk7Cgl9CgoJb2ZmID0gbHNlZWsoZmQsIG9mZiwgU0VF
S19TRVQpOwoJaWYgKG9mZiA9PSAtMSkgewoJCXBlcnJvcigibHNlZWsiKTsKCQlleGl0KDEp
OwoJfQoKCWZvciAoc2l6ZV90IGRvbmUgPSAwOyBkb25lIDwgY291bnQ7IGRvbmUgKz0gYnVm
c2l6ZSkgewoJCXNpemVfdCB0b19yZWFkID0gTUlOKGJ1ZnNpemUsIGNvdW50IC0gZG9uZSk7
CgkJc2l6ZV90IGJ1Zl9yZWFkID0gMDsKCgkJd2hpbGUgKHRvX3JlYWQgPiAwKSB7CgkJCXNz
aXplX3QgcmVhZF9vbmNlID0gcmVhZChmZCwgYnVmICsgYnVmX3JlYWQsIHRvX3JlYWQpOwoK
CQkJaWYgKHJlYWRfb25jZSA9PSAtMSkgewoJCQkJcGVycm9yKCJyZWFkIik7CgkJCQlleGl0
KDEpOwoJCQl9CgkJCWlmIChyZWFkX29uY2UgPT0gMCkgewoJCQkJcHJpbnRmKCJFT0Ygd2hp
bGUgcmVhZGluZ1xuIik7CgkJCQlyZXR1cm47CgkJCX0KCQkJdG9fcmVhZCAtPSByZWFkX29u
Y2U7CgkJCWJ1Zl9yZWFkICs9IHJlYWRfb25jZTsKCQl9CgoJCWZvciAoc2l6ZV90IHBvcyA9
IDA7IHBvcyA8IGJ1Zl9yZWFkOyBwb3MgKz0gUE1EX1NJWkUpIHsKCQkJdW5zaWduZWQgbG9u
ZyBhYnNfcG9zID0gb2ZmICsgZG9uZSArIHBvczsKCQkJdW5zaWduZWQgbG9uZyBmb3VuZF92
YWwgPSAqKCh1bnNpZ25lZCBsb25nICopKGJ1ZiArIHBvcykpIC0gTUFHSUNfVkFMVUU7CgkJ
CXVuc2lnbmVkIGxvbmcgZXhwZWN0ZWRfdmFsID0gYWJzX3BvcyAvIFBBR0VfU0laRTsKCgkJ
CWlmIChmb3VuZF92YWwgIT0gZXhwZWN0ZWRfdmFsKSB7CgkJCQlwcmludGYoIm1pc21hdGNo
IGF0IG9mZnNldCAlbGx1OiByZWFkIHZhbHVlIGV4cGVjdGVkIGZvciBvZmZzZXQgJWxsdSBp
bnN0ZWFkIG9mICVsbHVcbiIsCgkJCQkJCWFic19wb3MsIGZvdW5kX3ZhbCAqIFBBR0VfU0la
RSwgZXhwZWN0ZWRfdmFsICogUEFHRV9TSVpFKTsKCQkJfQoJCX0KCX0KCgltdW5tYXAoYnVm
LCBidWZzaXplKTsKfQoKI2RlZmluZSBNQVBfU0laRSAoMipQTURfU0laRSkKCmludCBtYWlu
KGludCBhcmdjLCBjaGFyICoqYXJndikKewoJaW50IGZkLCByZXQ7Cgl1bnNpZ25lZCBjaGFy
ICpidWY7CglwaWRfdCBwaWQ7CgoJaWYgKGFyZ2MgIT0gMikgewoJCXByaW50ZigidXNhZ2U6
ICVzIC9wYXRoL3RvL3Rlc3RfZmlsZVxuIiwgYXJndlswXSk7CgkJcHJpbnRmKCJ1c2UgYSBm
aWxlc3lzdGVtIHVzaW5nIGdlbmVyaWNfZmlsZV9yZWFkX2l0ZXIoKSBzdWNoIGFzIGV4dDMg
b3IgeGZzXG4iKTsKCQlleGl0KDEpOwoJfQoKCXdyaXRlX2ZpbGUoYXJndlsxXSwgTUFQX1NJ
WkUpOwoKCWZkID0gb3Blbihhcmd2WzFdLCBPX1JET05MWSk7CgoJaWYgKGZkID09IC0xKSB7
CgkJcGVycm9yKCJvcGVuIik7CgkJZXhpdCgxKTsKCX0KCglidWYgPSBtbWFwKCh2b2lkICop
MHg3MDAwMDAwMDAwMDBVTCwgTUFQX1NJWkUsIFBST1RfUkVBRHxQUk9UX0VYRUMsCgkJCU1B
UF9QUklWQVRFLCBmZCwgMCk7CgoJaWYgKGJ1ZiA9PSBNQVBfRkFJTEVEKSB7CgkJcGVycm9y
KCJtbWFwIGZhaWxlZCIpOwoJCWV4aXQoMSk7Cgl9CgoJcmV0ID0gbWFkdmlzZShidWYsIE1B
UF9TSVpFLCBNQURWX0hVR0VQQUdFKTsKCglpZiAocmV0KQoJCXBlcnJvcigibWFkdmlzZSIp
OwoKCXRvdWNoKGJ1ZiwgMCwgTUFQX1NJWkUpOwoKCXByaW50ZigicGlkOiAlZFxuIiwgZ2V0
cGlkKCkpOwoKCXByaW50ZigicHJlc3MgZW50ZXIgdG8gY29udGludWUgYWZ0ZXIga2h1Z2Vw
YWdlZCBoYXMgY29sbGFwc2VkIHRoZSBodWdlIHBhZ2VzXG4iKTsKCXByaW50ZigiY2hlY2sg
L3Byb2MvbWVtaW5mbyBGaWxlSHVnZVBhZ2VzOiB0byB2ZXJpZnlcbiIpOwoJcHJpbnRmKCJ1
c2UgJ2VjaG8gMTAwID4gL3N5cy9rZXJuZWwvbW0vdHJhbnNwYXJlbnRfaHVnZXBhZ2Uva2h1
Z2VwYWdlZC9zY2FuX3NsZWVwX21pbGxpc2VjcycgdG8gc3BlZWQga2h1Z2VwYWdlZCB1cFxu
Iik7CgoJZ2V0Y2hhcigpOwoKCXRvdWNoKGJ1ZiwgMCwgTUFQX1NJWkUpOwoKCXJldCA9IG11
bm1hcChidWYsIE1BUF9TSVpFKTsKCWlmIChyZXQpIHsKCQlwZXJyb3IoIm11bm1hcCIpOwoJ
CWV4aXQoMSk7Cgl9CgoJcmV0ID0gY2xvc2UoZmQpOwoJaWYgKHJldCkgewoJCXBlcnJvcigi
Y2xvc2UiKTsKCQlleGl0KDEpOwoJfQoKCWZkID0gb3Blbihhcmd2WzFdLCBPX1JET05MWSk7
CgoJaWYgKGZkID09IC0xKSB7CgkJcGVycm9yKCJvcGVuIik7CgkJZXhpdCgxKTsKCX0KCgl0
ZXN0X3JlYWQoZmQsIDAsIE1BUF9TSVpFLCBNQVBfU0laRSk7CgoJY2xvc2UoZmQpOwp9Cg==

--------------GrTvbgEqrrcmnHjnYyoN6t08
Content-Type: text/x-patch; charset=UTF-8; name="debug.patch"
Content-Disposition: attachment; filename="debug.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAuYwppbmRleCAzOWM0YzQ2
YzYxMzMuLmNlMzljMTVlODM3OSAxMDA2NDQKLS0tIGEvbW0vZmlsZW1hcC5jCisrKyBiL21t
L2ZpbGVtYXAuYwpAQCAtMjY4Miw2ICsyNjgyLDExIEBAIHNzaXplX3QgZmlsZW1hcF9yZWFk
KHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICppdGVyLAogCQkJCWJyZWFr
OwogCQkJaWYgKGkgPiAwKQogCQkJCW1hcmtfcGFnZV9hY2Nlc3NlZChwYWdlKTsKKworCQkJ
aWYgKHBhZ2Vfc2l6ZSA+IFBBR0VfU0laRSkKKwkJCQlwcl9pbmZvKCJpPSVkIHBhZ2U9JXB4
IHBhZ2Vfb2Zmc2V0PSVsbGQgb2ZmPSVsdSBieXRlcz0lbHVcbiIsCisJCQkJCQlpLCBwYWdl
LCBwYWdlX29mZnNldChwYWdlKSwgb2Zmc2V0LCBieXRlcyk7CisKIAkJCS8qCiAJCQkgKiBJ
ZiB1c2VycyBjYW4gYmUgd3JpdGluZyB0byB0aGlzIHBhZ2UgdXNpbmcgYXJiaXRyYXJ5CiAJ
CQkgKiB2aXJ0dWFsIGFkZHJlc3NlcywgdGFrZSBjYXJlIGFib3V0IHBvdGVudGlhbCBhbGlh
c2luZwo=

--------------GrTvbgEqrrcmnHjnYyoN6t08--
