Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BD06E5603
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 02:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDRAt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 20:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRAt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 20:49:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A02D47
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 17:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681778948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=diHA9YEvT+NtFZqSJc3EzoJvY5r/rokVVFb6FgdV/D8=;
        b=Dqy45OUKKMYlseLIfKAW6TrGR1bl3Ro+lfYb3MLCKHPdUrHcTXooKYTOu/A0qvA7nrCXBS
        2eUcoKu/y+dPq+hOtCNkvPF6enRPVe5dRogT3lSdhotx6Uwl0IoaW0JVW7bR+QkUhAaQqk
        eArAIX1en3KxfWHZMfRxo7wNGgU2DPA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-8Ai1AsBjMxGgkZgmkxZXtA-1; Mon, 17 Apr 2023 20:49:07 -0400
X-MC-Unique: 8Ai1AsBjMxGgkZgmkxZXtA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-51b121871ecso762885a12.3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 17:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681778946; x=1684370946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=diHA9YEvT+NtFZqSJc3EzoJvY5r/rokVVFb6FgdV/D8=;
        b=G8Kp+liw9rSJaJDJiTgTrhvlJHGUEBlYxakDXQziaU9tZP5KmH2c9ekx143X2EnigQ
         zp3VsVsij5MpT1dALHT5dedYuzuuqUU35Zg41emrgihWK3OhpihQXdWDNwlO48M5W5JW
         MSGOy4NQJGEaLXwzCLkJVUqq8ztCc8BaOlCL7PbwtQUED7XESUmue8Jm2nTyvEUFQP9J
         CfuUB3WbpTt8/oqCkXMJr9xw9iFRvoWLBHzpY8dYS9tsgnb7VxbVaDpbdV6QnoEpWNcC
         B3fbwjQLEjd2ZUFioDbHqwQLg/NDbs2YmNDKq4qytG9H686jn+FFUH3jkdYDovBhvqG9
         IMEg==
X-Gm-Message-State: AAQBX9f2ght7sic4yL2zDQhQDCIfGA62qaHDfRPxzFNGM1mhBAc6mhMT
        SdGKLvjx2puxjqiTX6edBcjpmLBNwr1QHHO324zY8UxW3f0Fjr0RERag2rgET+snCAr/BRD99d5
        IFjnsmBCJEZHVysUN0VKyRGYLkULeWA==
X-Received: by 2002:a17:902:d2c8:b0:1a6:99a6:3547 with SMTP id n8-20020a170902d2c800b001a699a63547mr497947plc.16.1681778945728;
        Mon, 17 Apr 2023 17:49:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZLidcrwgnD2ORGMZGJWazQqjpg3DYP/CbEZrByES+GDg/JznlImm1eUC0hmsfLrR31HxZ8jg==
X-Received: by 2002:a17:902:d2c8:b0:1a6:99a6:3547 with SMTP id n8-20020a170902d2c800b001a699a63547mr497925plc.16.1681778945405;
        Mon, 17 Apr 2023 17:49:05 -0700 (PDT)
Received: from [10.72.12.132] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902ed0200b001a6370bb33csm8294890pld.41.2023.04.17.17.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 17:49:04 -0700 (PDT)
Message-ID: <8cce2585-4cd8-9e33-35c7-8cec8f2ebac8@redhat.com>
Date:   Tue, 18 Apr 2023 08:48:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2] ceph: fix potential use-after-free bug when trimming
 caps
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230417120850.60880-1-xiubli@redhat.com>
 <87354yec53.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87354yec53.fsf@brahms.olymp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/17/23 23:55, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When trimming the caps and just after the 'session->s_cap_lock' is
>> released in ceph_iterate_session_caps() the cap maybe removed by
>> another thread, and when using the stale cap memory in the callbacks
>> it will trigger use-after-free crash.
>>
>> We need to check the existence of the cap just after the 'ci->i_ceph_lock'
>> being acquired. And do nothing if it's already removed.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2186264
> I didn't had time to look closer at what this patch is fixing but the
> above URL requires a account to access it.  So I guess it should be
> dropped or replaced by another one from the tracker...?

There already one old tracker to follow this 
https://tracker.ceph.com/issues/43272.

- Xiubo


> Also, just skimming through the patch, there are at least 2 obvious issues
> with it.  See below.
>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Fix this in ceph_iterate_session_caps instead.
>>
>>
>>   fs/ceph/debugfs.c    |  7 +++++-
>>   fs/ceph/mds_client.c | 56 ++++++++++++++++++++++++++++++--------------
>>   fs/ceph/mds_client.h |  2 +-
>>   3 files changed, 46 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>> index bec3c4549c07..5c0f07df5b02 100644
>> --- a/fs/ceph/debugfs.c
>> +++ b/fs/ceph/debugfs.c
>> @@ -248,14 +248,19 @@ static int metrics_caps_show(struct seq_file *s, void *p)
>>   	return 0;
>>   }
>>   
>> -static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
>> +static int caps_show_cb(struct inode *inode, struct rb_node *ci_node, void *p)
>>   {
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct seq_file *s = p;
>> +	struct ceph_cap *cap;
>>   
>> +	spin_lock(&ci->i_ceph_lock);
>> +	cap = rb_entry(ci_node, struct ceph_cap, ci_node);
>>   	seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
>>   		   cap->session->s_mds,
>>   		   ceph_cap_string(cap->issued),
>>   		   ceph_cap_string(cap->implemented));
>> +	spin_unlock(&ci->i_ceph_lock);
>>   	return 0;
>>   }
>>   
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 294af79c25c9..7fcfbddd534d 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1786,7 +1786,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>>    * Caller must hold session s_mutex.
>>    */
>>   int ceph_iterate_session_caps(struct ceph_mds_session *session,
>> -			      int (*cb)(struct inode *, struct ceph_cap *,
>> +			      int (*cb)(struct inode *, struct rb_node *ci_node,
>>   					void *), void *arg)
>>   {
>>   	struct list_head *p;
>> @@ -1799,6 +1799,8 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   	spin_lock(&session->s_cap_lock);
>>   	p = session->s_caps.next;
>>   	while (p != &session->s_caps) {
>> +		struct rb_node *ci_node;
>> +
>>   		cap = list_entry(p, struct ceph_cap, session_caps);
>>   		inode = igrab(&cap->ci->netfs.inode);
>>   		if (!inode) {
>> @@ -1806,6 +1808,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   			continue;
>>   		}
>>   		session->s_cap_iterator = cap;
>> +		ci_node = &cap->ci_node;
>>   		spin_unlock(&session->s_cap_lock);
>>   
>>   		if (last_inode) {
>> @@ -1817,7 +1820,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   			old_cap = NULL;
>>   		}
>>   
>> -		ret = cb(inode, cap, arg);
>> +		ret = cb(inode, ci_node, arg);
>>   		last_inode = inode;
>>   
>>   		spin_lock(&session->s_cap_lock);
>> @@ -1850,17 +1853,22 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   	return ret;
>>   }
>>   
>> -static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>> +static int remove_session_caps_cb(struct inode *inode, struct rb_node *ci_node,
>>   				  void *arg)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	bool invalidate = false;
>> +	struct ceph_cap *cap;
>>   	int iputs;
>>   
>> -	dout("removing cap %p, ci is %p, inode is %p\n",
>> -	     cap, ci, &ci->netfs.inode);
>>   	spin_lock(&ci->i_ceph_lock);
>> -	iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
> This will leave iputs uninitialized if the statement below returns NULL.
> Which will cause issues later in the function.
>
>> +	cap = rb_entry(ci_node, struct ceph_cap, ci_node);
>> +	if (cap) {
>> +		dout(" removing cap %p, ci is %p, inode is %p\n",
>> +		     cap, ci, &ci->netfs.inode);
>> +
>> +		iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
>> +	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>   	wake_up_all(&ci->i_cap_wq);
>> @@ -1934,11 +1942,11 @@ enum {
>>    *
>>    * caller must hold s_mutex.
>>    */
>> -static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
>> -			      void *arg)
>> +static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	unsigned long ev = (unsigned long)arg;
>> +	struct ceph_cap *cap;
>>   
>>   	if (ev == RECONNECT) {
>>   		spin_lock(&ci->i_ceph_lock);
>> @@ -1949,7 +1957,9 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
>>   		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
> Since we're replacing the 'cap' argument by the 'ci_node', the
> above statement will have garbage in 'cap'.
>
> Cheers,

