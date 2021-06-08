Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABDC3A0447
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhFHT2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236250AbhFHT0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5AE61182;
        Tue,  8 Jun 2021 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623180262;
        bh=kLhaSghSgBwEu/dvnPHLV1+DrLdfAjIKHtB0UzKfxcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cF7CEzvwv5dy8C72+Mtnvrc5fm4zVoihnZSpfmFv7p3fhPsKvPiv/N/NEyDtgPZ7F
         VFtosUje3C8+fu4SXUESCIWz9cBVIW1U5uUX17aSeFNCtG2m2LJDGqwe+MCM/Fqc3P
         f7iY96wvKMvW2+LH1KeFC03ZIl+7ntF3DBh5mL4NPg3sZoa1SOmPH93/uighkjz2Y1
         L0x5YHEJAJds/cAN94VT9j7ORaS5Jvu5t5k+01cLhHvnC2sufAlHhtZloU/s7uTzgk
         V25GWbdRFinVAUxJeHKGZvPnpFEyL7q/AhBxpYXfTEgSIEixcRPG478qVUeRlRzEp3
         5hmdqxvCsvLBw==
Date:   Tue, 8 Jun 2021 15:24:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Sage Weil <sage@redhat.com>
Subject: Re: [PATCH 5.12 083/161] libceph: dont set global_id until we get an
 auth ticket
Message-ID: <YL/D5ecAFFyPBXDF@sashalap>
References: <20210608175945.476074951@linuxfoundation.org>
 <20210608175948.243493420@linuxfoundation.org>
 <CAOi1vP-B4A4bmd=ZbnwqEa14BizN-X8V4ktUMWGuEtXu8n2y-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP-B4A4bmd=ZbnwqEa14BizN-X8V4ktUMWGuEtXu8n2y-g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 09:07:18PM +0200, Ilya Dryomov wrote:
>On Tue, Jun 8, 2021 at 8:48 PM Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> From: Ilya Dryomov <idryomov@gmail.com>
>>
>> [ Upstream commit 61ca49a9105faefa003b37542cebad8722f8ae22 ]
>>
>> With the introduction of enforcing mode, setting global_id as soon
>> as we get it in the first MAuth reply will result in EACCES if the
>> connection is reset before we get the second MAuth reply containing
>> an auth ticket -- because on retry we would attempt to reclaim that
>> global_id with no auth ticket at hand.
>>
>> Neither ceph_auth_client nor ceph_mon_client depend on global_id
>> being set ealy, so just delay the setting until we get and process
>> the second MAuth reply.  While at it, complain if the monitor sends
>> a zero global_id or changes our global_id as the session is likely
>> to fail after that.
>>
>> Cc: stable@vger.kernel.org # needs backporting for < 5.11
>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Reviewed-by: Sage Weil <sage@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  net/ceph/auth.c | 36 +++++++++++++++++++++++-------------
>>  1 file changed, 23 insertions(+), 13 deletions(-)
>>
>> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
>> index eb261aa5fe18..de407e8feb97 100644
>> --- a/net/ceph/auth.c
>> +++ b/net/ceph/auth.c
>> @@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
>>         }
>>  }
>>
>> +static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
>> +{
>> +       dout("%s global_id %llu\n", __func__, global_id);
>> +
>> +       if (!global_id)
>> +               pr_err("got zero global_id\n");
>> +
>> +       if (ac->global_id && global_id != ac->global_id)
>> +               pr_err("global_id changed from %llu to %llu\n", ac->global_id,
>> +                      global_id);
>> +
>> +       ac->global_id = global_id;
>> +}
>> +
>>  /*
>>   * setup, teardown.
>>   */
>> @@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>>
>>         payload_end = payload + payload_len;
>>
>> -       if (global_id && ac->global_id != global_id) {
>> -               dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
>> -               ac->global_id = global_id;
>> -       }
>> -
>>         if (ac->negotiating) {
>>                 /* server does not support our protocols? */
>>                 if (!protocol && result < 0) {
>> @@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>>
>>         ret = ac->ops->handle_reply(ac, result, payload, payload_end,
>>                                     NULL, NULL, NULL, NULL);
>> -       if (ret == -EAGAIN)
>> +       if (ret == -EAGAIN) {
>>                 ret = build_request(ac, true, reply_buf, reply_len);
>> -       else if (ret)
>> +               goto out;
>> +       } else if (ret) {
>>                 pr_err("auth protocol '%s' mauth authentication failed: %d\n",
>>                        ceph_auth_proto_name(ac->protocol), result);
>> +               goto out;
>> +       }
>> +
>> +       set_global_id(ac, global_id);
>>
>>  out:
>>         mutex_unlock(&ac->mutex);
>> @@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
>>         int ret;
>>
>>         mutex_lock(&ac->mutex);
>> -       if (global_id && ac->global_id != global_id) {
>> -               dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
>> -                    global_id);
>> -               ac->global_id = global_id;
>> -       }
>> -
>>         ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
>>                                     session_key, session_key_len,
>>                                     con_secret, con_secret_len);
>> +       if (!ret)
>> +               set_global_id(ac, global_id);
>>         mutex_unlock(&ac->mutex);
>>         return ret;
>>  }
>
>Hi Greg,
>
>I asked Sasha to drop this patch earlier today.

I've dropped it now, but I think I'm missing your previous request. Was
it as a reply to the added-to mail? I just want to make sure I'm not
missing your mails.

-- 
Thanks,
Sasha
