Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08066B1ACD
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 06:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCIFch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 00:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCIFcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 00:32:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018FEDABA1
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 21:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678339863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NF+hRgTvNfgmlgjECsBfqeiS0Fv+B2tyOOlTKhNVTBk=;
        b=ih4S9duKpr7B43P2kMzqWO9DsNFaK3Ugpm9r6PdzbvRNFWbyIBhIURc7ymKF6cetv50Hjh
        wRBfC2+7qFDDGf79ABdyiNFLuIdnA0TNlszyElr+yvwSWsq81mKS/Xn0FGVSEeLkSWBDOg
        4zHGQeWPSGsu2y4C1tl5tVAzGQ8Ptps=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-MrJf8XddM9qEuTMsnnNQbA-1; Thu, 09 Mar 2023 00:31:02 -0500
X-MC-Unique: MrJf8XddM9qEuTMsnnNQbA-1
Received: by mail-pl1-f198.google.com with SMTP id t24-20020a1709028c9800b0019eaa064a51so531694plo.10
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 21:31:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678339861;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NF+hRgTvNfgmlgjECsBfqeiS0Fv+B2tyOOlTKhNVTBk=;
        b=FebusKvQjdPj33exBAawdv7lKpv0DMvk4ESD+4hNjs3hGUuFmB2XA2K6FOnPNIhl2B
         8THZ938je24i7t2cQkkTRPaG7/maXJ5uOkf+CVFk0Y23LXyt5XyP/BPm+5ZlvJORrii3
         wjgFI25L+yWdBbj0RJ20TFTTZ9ImQ3wzWSvWgEpcDaUqsnaqu3wtMox5NlALDs372gdh
         0wgenVqth71PppYmqBnPiula/x9phA6kw68oerJGdnmKr6EghMxC99UoAIao5wOgTYva
         pmLPuxwkuWXD6qhleiI9GfVVDPfFdJKpjCG/kgTFzfJqWklxGwGxDVuuiWPgXU5nhKqe
         601w==
X-Gm-Message-State: AO0yUKWJ7CxdxfbCvmh10w89sjVzPXY4kuEcTXfpVDrjFLrcSDP5LYoS
        2YQZm8e4DlLRzyVHbF3Y0TVcntMUq+laMP7Bpj8Do4jc9Ts+9KAltdG/5NkoBY2psra2mDkLqoi
        viemib5C8JrZhscxh
X-Received: by 2002:a17:902:8303:b0:19e:6516:127a with SMTP id bd3-20020a170902830300b0019e6516127amr16656912plb.39.1678339861054;
        Wed, 08 Mar 2023 21:31:01 -0800 (PST)
X-Google-Smtp-Source: AK7set8/A14OcinraypJh2YtkGvwipZHtLDr/jVtglsBDKiEWbxU1KHRkvnxTMyVtYesgeU7EFQ5cQ==
X-Received: by 2002:a17:902:8303:b0:19e:6516:127a with SMTP id bd3-20020a170902830300b0019e6516127amr16656886plb.39.1678339860614;
        Wed, 08 Mar 2023 21:31:00 -0800 (PST)
Received: from [10.72.13.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f54a00b0019c13c4b175sm10616783plf.189.2023.03.08.21.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 21:31:00 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------dq4f42jxE1QnjnQr5D0c0j29"
Message-ID: <cf545923-e782-76a7-dd94-f8586530502b@redhat.com>
Date:   Thu, 9 Mar 2023 13:30:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
Content-Language: en-US
To:     Max Kellermann <max.kellermann@ionos.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230302130650.2209938-1-max.kellermann@ionos.com>
 <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com>
 <CAKPOu+_1ee8QDkuB4TxQBaUwnHi4bRKuszWzCb-BCY44cp1aJQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAKPOu+_1ee8QDkuB4TxQBaUwnHi4bRKuszWzCb-BCY44cp1aJQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------dq4f42jxE1QnjnQr5D0c0j29
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 08/03/2023 23:17, Max Kellermann wrote:
> On Wed, Mar 8, 2023 at 4:42 AM Xiubo Li <xiubli@redhat.com> wrote:
>> How could this happen ?
>>
>> Since the req hasn't been submitted yet, how could it receive a reply
>> normally ?
> I have no idea. We have frequent problems with MDS closing the
> connection (once or twice a week), and sometimes, this leads to the
> WARNING problem which leaves the server hanging. This seems to be some
> timing problem, but that MDS connection problem is a different
> problem.
> My patch just attempts to address the WARNING; not knowing much about
> Ceph internals, my idea was that even if the server sends bad reply
> packets, the client shouldn't panic.
>
>> It should be a corrupted reply and it lead us to get a incorrect req,
>> which hasn't been submitted yet.
>>
>> BTW, do you have the dump of the corrupted msg by 'ceph_msg_dump(msg)' ?
> Unfortunately not - we have already scrubbed the server that had this
> problem and rebooted it with a fresh image including my patch. It
> seems I don't have a full copy of the kernel log anymore.
>
> Coincidentally, the patch has prevented another kernel hang just a few
> minutes ago:
>
>   Mar 08 15:48:53 sweb1 kernel: ceph: mds0 caps stale
>   Mar 08 15:49:13 sweb1 kernel: ceph: mds0 caps stale
>   Mar 08 15:49:35 sweb1 kernel: ceph: mds0 caps went stale, renewing
>   Mar 08 15:49:35 sweb1 kernel: ceph: mds0 caps stale
>   Mar 08 15:49:35 sweb1 kernel: libceph: mds0 (1)10.41.2.11:6801 socket
> error on write
>   Mar 08 15:49:35 sweb1 kernel: libceph: mds0 (1)10.41.2.11:6801 session reset
>   Mar 08 15:49:35 sweb1 kernel: ceph: mds0 closed our session
>   Mar 08 15:49:35 sweb1 kernel: ceph: mds0 reconnect start
>   Mar 08 15:49:36 sweb1 kernel: ceph: mds0 reconnect success
>   Mar 08 15:49:36 sweb1 kernel: ceph:  dropping dirty+flushing Fx state
> for 0000000064778286 2199046848012
>   Mar 08 15:49:40 sweb1 kernel: ceph: mdsc_handle_reply on waiting
> request tid 1106187
>   Mar 08 15:49:53 sweb1 kernel: ceph: mds0 caps renewed
>
> Since my patch is already in place, the kernel hasn't checked the
> unexpected packet and thus hasn't dumped it....
>
> If you need more information and have a patch with more logging, I
> could easily boot those servers with your patch and post that data
> next time it happens.

Hi Max,

I figured out one possible case:

For example when mds closes our session the kclient will call 
'cleanup_session_requests()', which will drop the unsafe requests and 
then set 'req->r_attempts' to 0, that means for the requests if they 
were sent out without receiving unsafe reply they will be retried and 
then they will be possibly added to the wait list in '__do_request()'. 
If these requests will get a reply later just after being retried we 
could see this warning.

I attached one testing patch based yours, just added more debug logs, 
which won't be introduce perf issue since all the logs should be printed 
in corner cases.

Could you help test it ?

Thanks,

- Xiubo

> Max
>
--------------dq4f42jxE1QnjnQr5D0c0j29
Content-Type: text/x-patch; charset=UTF-8; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2NlcGgvbWRzX2NsaWVudC5jIGIvZnMvY2VwaC9tZHNfY2xpZW50
LmMKaW5kZXggYjhkNmNjYTE2MDA1Li41MmY1ZTQwYTM0MWQgMTAwNjQ0Ci0tLSBhL2ZzL2Nl
cGgvbWRzX2NsaWVudC5jCisrKyBiL2ZzL2NlcGgvbWRzX2NsaWVudC5jCkBAIC0xNzU0LDcg
KzE3NTQsNyBAQCBzdGF0aWMgdm9pZCBjbGVhbnVwX3Nlc3Npb25fcmVxdWVzdHMoc3RydWN0
IGNlcGhfbWRzX2NsaWVudCAqbWRzYywKIAlzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdCAqcmVx
OwogCXN0cnVjdCByYl9ub2RlICpwOwogCi0JZG91dCgiY2xlYW51cF9zZXNzaW9uX3JlcXVl
c3RzIG1kcyVkXG4iLCBzZXNzaW9uLT5zX21kcyk7CisJcHJfaW5mbygiY2xlYW51cF9zZXNz
aW9uX3JlcXVlc3RzIG1kcyVkXG4iLCBzZXNzaW9uLT5zX21kcyk7CiAJbXV0ZXhfbG9jaygm
bWRzYy0+bXV0ZXgpOwogCXdoaWxlICghbGlzdF9lbXB0eSgmc2Vzc2lvbi0+c191bnNhZmUp
KSB7CiAJCXJlcSA9IGxpc3RfZmlyc3RfZW50cnkoJnNlc3Npb24tPnNfdW5zYWZlLApAQCAt
MTc3Myw4ICsxNzczLDEyIEBAIHN0YXRpYyB2b2lkIGNsZWFudXBfc2Vzc2lvbl9yZXF1ZXN0
cyhzdHJ1Y3QgY2VwaF9tZHNfY2xpZW50ICptZHNjLAogCQlyZXEgPSByYl9lbnRyeShwLCBz
dHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdCwgcl9ub2RlKTsKIAkJcCA9IHJiX25leHQocCk7CiAJ
CWlmIChyZXEtPnJfc2Vzc2lvbiAmJgotCQkgICAgcmVxLT5yX3Nlc3Npb24tPnNfbWRzID09
IHNlc3Npb24tPnNfbWRzKQorCQkgICAgcmVxLT5yX3Nlc3Npb24tPnNfbWRzID09IHNlc3Np
b24tPnNfbWRzKSB7CisJCQlpZiAocmVxLT5yX2F0dGVtcHRzKQorCQkJCXByX2luZm8oIm1k
cyVkIHJlcSB0aWQgJWxsdSByZWF0dGVtcHRlZFxuIiwKKwkJCQkJc2Vzc2lvbi0+c19tZHMs
IHJlcS0+cl90aWQpOwogCQkJcmVxLT5yX2F0dGVtcHRzID0gMDsKKwkJfQogCX0KIAltdXRl
eF91bmxvY2soJm1kc2MtPm11dGV4KTsKIH0KQEAgLTMyMzUsNyArMzIzOSw4IEBAIHN0YXRp
YyB2b2lkIF9fZG9fcmVxdWVzdChzdHJ1Y3QgY2VwaF9tZHNfY2xpZW50ICptZHNjLAogCQkJ
Z290byBmaW5pc2g7CiAJCX0KIAkJaWYgKG1kc2MtPm1kc21hcC0+bV9lcG9jaCA9PSAwKSB7
Ci0JCQlkb3V0KCJkb19yZXF1ZXN0IG5vIG1kc21hcCwgd2FpdGluZyBmb3IgbWFwXG4iKTsK
KwkJCXByX2luZm8oImRvX3JlcXVlc3Qgbm8gbWRzbWFwLCB3YWl0aW5nIGZvciBtYXAgcmVx
IHRpZCAlbGx1XG4iLAorCQkJCXJlcS0+cl90aWQpOwogCQkJbGlzdF9hZGQoJnJlcS0+cl93
YWl0LCAmbWRzYy0+d2FpdGluZ19mb3JfbWFwKTsKIAkJCXJldHVybjsKIAkJfQpAQCAtMzI1
Niw3ICszMjYxLDggQEAgc3RhdGljIHZvaWQgX19kb19yZXF1ZXN0KHN0cnVjdCBjZXBoX21k
c19jbGllbnQgKm1kc2MsCiAJCQllcnIgPSAtRUpVS0VCT1g7CiAJCQlnb3RvIGZpbmlzaDsK
IAkJfQotCQlkb3V0KCJkb19yZXF1ZXN0IG5vIG1kcyBvciBub3QgYWN0aXZlLCB3YWl0aW5n
IGZvciBtYXBcbiIpOworCQlwcl9pbmZvKCJkb19yZXF1ZXN0IG5vIG1kcyBvciBub3QgYWN0
aXZlLCB3YWl0aW5nIGZvciBtYXAgcmVxIHRpZCAlbGx1XG4iLAorCQkJcmVxLT5yX3RpZCk7
CiAJCWxpc3RfYWRkKCZyZXEtPnJfd2FpdCwgJm1kc2MtPndhaXRpbmdfZm9yX21hcCk7CiAJ
CXJldHVybjsKIAl9CkBAIC0zMzAyLDggKzMzMDgsMTAgQEAgc3RhdGljIHZvaWQgX19kb19y
ZXF1ZXN0KHN0cnVjdCBjZXBoX21kc19jbGllbnQgKm1kc2MsCiAJCSAqIGl0IHRvIHRoZSBt
ZHNjIHF1ZXVlLgogCQkgKi8KIAkJaWYgKHNlc3Npb24tPnNfc3RhdGUgPT0gQ0VQSF9NRFNf
U0VTU0lPTl9SRUpFQ1RFRCkgewotCQkJaWYgKGNlcGhfdGVzdF9tb3VudF9vcHQobWRzYy0+
ZnNjLCBDTEVBTlJFQ09WRVIpKQorCQkJaWYgKGNlcGhfdGVzdF9tb3VudF9vcHQobWRzYy0+
ZnNjLCBDTEVBTlJFQ09WRVIpKSB7CisJCQkJcHJfaW5mbygiIENMRUFOUkVDT1ZFUiByZXEg
dGlkICVsbHVcbiIsIHJlcS0+cl90aWQpOwogCQkJCWxpc3RfYWRkKCZyZXEtPnJfd2FpdCwg
Jm1kc2MtPndhaXRpbmdfZm9yX21hcCk7CisJCQl9CiAJCQllbHNlCiAJCQkJZXJyID0gLUVB
Q0NFUzsKIAkJCWdvdG8gb3V0X3Nlc3Npb247CkBAIC0zMzE4LDYgKzMzMjYsNyBAQCBzdGF0
aWMgdm9pZCBfX2RvX3JlcXVlc3Qoc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYywKIAkJ
CWlmIChyYW5kb20pCiAJCQkJcmVxLT5yX3Jlc2VuZF9tZHMgPSBtZHM7CiAJCX0KKwkJcHJf
aW5mbygiIHNlc3Npb24gaXMgbm90IG9wZW5lZCwgcmVxIHRpZCAlbGx1XG4iLCByZXEtPnJf
dGlkKTsKIAkJbGlzdF9hZGQoJnJlcS0+cl93YWl0LCAmc2Vzc2lvbi0+c193YWl0aW5nKTsK
IAkJZ290byBvdXRfc2Vzc2lvbjsKIAl9CkBAIC0zNjIxLDYgKzM2MzAsMTQgQEAgc3RhdGlj
IHZvaWQgaGFuZGxlX3JlcGx5KHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICpzZXNzaW9uLCBz
dHJ1Y3QgY2VwaF9tc2cgKm1zZykKIAl9CiAJZG91dCgiaGFuZGxlX3JlcGx5ICVwXG4iLCBy
ZXEpOwogCisJLyogd2FpdGluZywgbm90IHlldCBzdWJtaXR0ZWQ/ICovCisJaWYgKCFsaXN0
X2VtcHR5KCZyZXEtPnJfd2FpdCkpIHsKKwkJcHJfZXJyKCJtZHNjX2hhbmRsZV9yZXBseSBv
biB3YWl0aW5nIHJlcXVlc3QgdGlkICVsbHVcbiIsIHRpZCk7CisJCW11dGV4X3VubG9jaygm
bWRzYy0+bXV0ZXgpOworCQljZXBoX21zZ19kdW1wKG1zZyk7CisJCWdvdG8gb3V0OworCX0K
KwogCS8qIGNvcnJlY3Qgc2Vzc2lvbj8gKi8KIAlpZiAocmVxLT5yX3Nlc3Npb24gIT0gc2Vz
c2lvbikgewogCQlwcl9lcnIoIm1kc2NfaGFuZGxlX3JlcGx5IGdvdCAlbGx1IG9uIHNlc3Np
b24gbWRzJWQiCkBAIC00MDE5LDYgKzQwMzYsNyBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfc2Vz
c2lvbihzdHJ1Y3QgY2VwaF9tZHNfc2Vzc2lvbiAqc2Vzc2lvbiwKIAljYXNlIENFUEhfU0VT
U0lPTl9DTE9TRToKIAkJaWYgKHNlc3Npb24tPnNfc3RhdGUgPT0gQ0VQSF9NRFNfU0VTU0lP
Tl9SRUNPTk5FQ1RJTkcpCiAJCQlwcl9pbmZvKCJtZHMlZCByZWNvbm5lY3QgZGVuaWVkXG4i
LCBzZXNzaW9uLT5zX21kcyk7CisJCXByX2luZm8oIm1kcyVkIGNsb3NlZCBvdXIgc2Vzc2lv
blxuIiwgc2Vzc2lvbi0+c19tZHMpOwogCQlzZXNzaW9uLT5zX3N0YXRlID0gQ0VQSF9NRFNf
U0VTU0lPTl9DTE9TRUQ7CiAJCWNsZWFudXBfc2Vzc2lvbl9yZXF1ZXN0cyhtZHNjLCBzZXNz
aW9uKTsKIAkJcmVtb3ZlX3Nlc3Npb25fY2FwcyhzZXNzaW9uKTsKQEAgLTQ3MjcsNiArNDc0
NSw3IEBAIHN0YXRpYyB2b2lkIGNoZWNrX25ld19tYXAoc3RydWN0IGNlcGhfbWRzX2NsaWVu
dCAqbWRzYywKIAkJCV9fd2FrZV9yZXF1ZXN0cyhtZHNjLCAmcy0+c193YWl0aW5nKTsKIAkJ
CW11dGV4X3VubG9jaygmbWRzYy0+bXV0ZXgpOwogCisJCQlwcl9pbmZvKCJjaGVja19uZXdf
bWFwIGV4Y2VlZCBtYXggcmFuayBtZHMlZFxuIiwgaSk7CiAJCQltdXRleF9sb2NrKCZzLT5z
X211dGV4KTsKIAkJCWNsZWFudXBfc2Vzc2lvbl9yZXF1ZXN0cyhtZHNjLCBzKTsKIAkJCXJl
bW92ZV9zZXNzaW9uX2NhcHMocyk7CkBAIC01NDgzLDYgKzU1MDIsNyBAQCB2b2lkIGNlcGhf
bWRzY19mb3JjZV91bW91bnQoc3RydWN0IGNlcGhfbWRzX2NsaWVudCAqbWRzYykKIAkJbXV0
ZXhfbG9jaygmc2Vzc2lvbi0+c19tdXRleCk7CiAJCV9fY2xvc2Vfc2Vzc2lvbihtZHNjLCBz
ZXNzaW9uKTsKIAkJaWYgKHNlc3Npb24tPnNfc3RhdGUgPT0gQ0VQSF9NRFNfU0VTU0lPTl9D
TE9TSU5HKSB7CisJCQlwcl9pbmZvKCJjZXBoX21kc2NfZm9yY2VfdW1vdW50IG1kcyVkXG4i
LCBtZHMpOwogCQkJY2xlYW51cF9zZXNzaW9uX3JlcXVlc3RzKG1kc2MsIHNlc3Npb24pOwog
CQkJcmVtb3ZlX3Nlc3Npb25fY2FwcyhzZXNzaW9uKTsKIAkJfQo=

--------------dq4f42jxE1QnjnQr5D0c0j29--

