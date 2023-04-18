Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40796E55FF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 02:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDRArK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 20:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjDRArK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 20:47:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CABC40CC
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 17:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681778782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kBRdIQDf0Ic5mOgqQ8hzcLXk0N2+ZyD5LwxT1KPnvE=;
        b=LT6w/jQTWxsGUgO2xja+249p9gxK7UdZ9cYuWRFDECvhYQ/UavcZek5Zt6XWESkKXVXZxX
        fB+DrvUGoChcxtCuhj0j1IsGYdSIVGpHmX4HamCJF+NL08QSv52UDuJX5JOmpNzcGexu1c
        DncusCzm2LBmTuVAqxm4R0j2w1KCppU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-iW2nqDk2OJ6_6HDvccA73A-1; Mon, 17 Apr 2023 20:46:20 -0400
X-MC-Unique: iW2nqDk2OJ6_6HDvccA73A-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-63b5a2099a6so1169436b3a.3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 17:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681778779; x=1684370779;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1kBRdIQDf0Ic5mOgqQ8hzcLXk0N2+ZyD5LwxT1KPnvE=;
        b=hGHChsgcaNeXlruYfFAWrVAtX3nIDNP6Wucg/LAYhbISy4la2nKi4LG8NyWG6xxLXQ
         YeWVuC6/C6GvGFlLt26pldlze1/rdVDkZ0wL0XCB+gdGAZaX1N+JO0TQlGTt8NS4iCuw
         Hy4mU0M9rsJWE0ctAg5GB0Gd3oh9XYzE84UwuhXgi5euJ1cbxq3z2q2BVecoqa1n5WSG
         42yzoyMv5V8BA2YnYezQVa0PkqGRxHEKyI9nc8mEYpzfiB34sfJnVXm8DtgqV19HTijt
         FY6g7KoxPjgCDGL3XEamfTOYEcW6UFr8qXY1jfd4EvJD5LJBC2DK+mF8glF8AU48+t1K
         3yDA==
X-Gm-Message-State: AAQBX9emecVHEVzBKJD+zScib9s7kXTH7/ata0vbbOpBxrIaTdaHkbH9
        cLOwiKVNxgJv/ziyAGTMFSW7F82FvKFyYKEGR6HNRRuELSM5n2pji6uBr/X7T+XGgBUoZPV7kgj
        b0ybxE4Ij1UExX/G0
X-Received: by 2002:a05:6a00:2401:b0:626:2ce1:263c with SMTP id z1-20020a056a00240100b006262ce1263cmr22032196pfh.5.1681778779639;
        Mon, 17 Apr 2023 17:46:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350agGn681cW74wCuJ3U3D7M89+HLHpHmPzb5KJTnDdtWP2UelPdmkLMI+M0zlxt+SfGo0uF5Vw==
X-Received: by 2002:a05:6a00:2401:b0:626:2ce1:263c with SMTP id z1-20020a056a00240100b006262ce1263cmr22032174pfh.5.1681778779296;
        Mon, 17 Apr 2023 17:46:19 -0700 (PDT)
Received: from [10.72.12.132] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e2-20020aa78c42000000b0063b7af71b61sm4727567pfd.212.2023.04.17.17.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 17:46:18 -0700 (PDT)
Message-ID: <25c0ca08-20a5-05b1-666a-f95252be6834@redhat.com>
Date:   Tue, 18 Apr 2023 08:46:12 +0800
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Make sense.


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

Yeah, correct. It seems some configuration are not enabled when 
compiling the code locally, it doesn't complain about this.


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

Yeah, should check the cap first.

Thanks

- Xiubo


>
> Cheers,

