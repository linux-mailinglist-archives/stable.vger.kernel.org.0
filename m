Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8836A5A0E
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 14:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjB1NhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 08:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjB1Ng7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 08:36:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309BDCDC1
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 05:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677591384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmEe2aFYLrL01QMLfNB1C23g+1bhS2BKXbPiVAwejiU=;
        b=XuhfuYBRkSPEGx0MDubyuW7AEGJdQ2oF7dG2A0sChxot7cjyGGSpZS7fzRbrur4LuYkofB
        0ERX8y571pZAEpMpWW25bsagXYTaROa1k1efG/1QuIEqlG2UnEjKdwPgyrBB78ZMD1X6VM
        6Ys1f7grrNhv1s5HpbIQVbsuSdIdFiE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-oowvXWZuPDmMfSo0ogQU6w-1; Tue, 28 Feb 2023 08:36:23 -0500
X-MC-Unique: oowvXWZuPDmMfSo0ogQU6w-1
Received: by mail-pg1-f198.google.com with SMTP id v24-20020a631518000000b00502e6bfe335so3339475pgl.2
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 05:36:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677591382;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmEe2aFYLrL01QMLfNB1C23g+1bhS2BKXbPiVAwejiU=;
        b=U2ZW4fM/xwG9Vs+uqM2oB8ilYDx0fL3Yfh8EPj51ZhlPgMSsisMF0E9oOxOc5pR2sS
         bNZxj+/3TZKvDQYWY5pHtsJ7p9KSRiIXQor+CSNJdv0182at2TSpZMIZJXi/1M00sLAJ
         HxiTnNHF7cGJfMQ6/nAe3nAkK+fa+B6v+JwdDIYHst1WSQuogv/kKKiSCqLTZVg+sOo3
         yL2jQl/birGYCoanuxvINwvESqzTfnZE+g8zSPEaLlP/Zk1+/aru9swHgiLF6nf10q0x
         w7Pk4SyZ9o4s8OCoa2DuxcI4AViUhuEAgsZnIN+tIpt20S946u7Ury4kF2HJe3dVScdH
         kt8Q==
X-Gm-Message-State: AO0yUKV4sSWpdvltJT5QXRUVz2vF6Lq0fV8sCgYadyznxY3bqoZcmsD0
        feXDLvGHQNlpGuuTPR4gGt291+21lnX5Yecw+TfHJCCCmoD3DZ1ZcPCaX8Sd5RejBVxeEyXxomU
        Z5pitDPgS0lN8tpQ3
X-Received: by 2002:a62:7b8e:0:b0:5a8:d364:62ab with SMTP id w136-20020a627b8e000000b005a8d36462abmr2247388pfc.17.1677591382262;
        Tue, 28 Feb 2023 05:36:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+7qVfLk6FNBGfSRuJAv6UdVq1EAi1Nmshfuud77oqOomkDhptfItB8psW6WJ7aqxtKexQiQA==
X-Received: by 2002:a62:7b8e:0:b0:5a8:d364:62ab with SMTP id w136-20020a627b8e000000b005a8d36462abmr2247373pfc.17.1677591381904;
        Tue, 28 Feb 2023 05:36:21 -0800 (PST)
Received: from [10.72.12.46] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m12-20020aa78a0c000000b005a8ae0c52cfsm6308800pfa.16.2023.02.28.05.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 05:36:21 -0800 (PST)
Message-ID: <49813ffb-f2e9-0453-8b79-ec133d8e3110@redhat.com>
Date:   Tue, 28 Feb 2023 21:36:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ceph: do not print the whole xattr value if it's too long
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, vshankar@redhat.com, mchangir@redhat.com,
        stable@vger.kernel.org
References: <20230228125531.165361-1-xiubli@redhat.com>
 <12ed3a557618c331c6a5949f7335d563cdc1531c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <12ed3a557618c331c6a5949f7335d563cdc1531c.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/02/2023 21:29, Jeff Layton wrote:
> On Tue, 2023-02-28 at 20:55 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the xattr's value size is long enough the kernel will warn and
>> then will fail the xfstests test case.
>>
>> Just print part of the value string if it's too long.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/58404
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/xattr.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index b10d459c2326..6638bb0ec10f 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -561,6 +561,7 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>>   	return NULL;
>>   }
>>   
>> +#define XATTR_MAX_VAL 256
>>   static int __set_xattr(struct ceph_inode_info *ci,
>>   			   const char *name, int name_len,
>>   			   const char *val, int val_len,
>> @@ -654,8 +655,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
>>   		dout("__set_xattr_val p=%p\n", p);
>>   	}
>>   
>> -	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s\n",
>> -	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val);
>> +	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s%s\n",
>> +	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
>> +	     val_len > XATTR_MAX_VAL ? XATTR_MAX_VAL : val_len, val,
> 		min(val_len, XATTR_MAX_VAL), val,...
>
>> +	     val_len > XATTR_MAX_VAL ? "..." : "");
>>   
>>   	return 0;
>>   }
>> @@ -681,8 +684,10 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
>>   		else if (c > 0)
>>   			p = &(*p)->rb_right;
>>   		else {
>> -			dout("__get_xattr %s: found %.*s\n", name,
>> -			     xattr->val_len, xattr->val);
>> +			int len = xattr->val_len;
>> +			dout("__get_xattr %s: found %.*s%s\n", name,
>> +			     len > XATTR_MAX_VAL ? XATTR_MAX_VAL : len,
> 				min(len, XATTR_MAX_VAL)

Cool. I will revise this.

Thanks Jeff.


>
>> +			     xattr->val, len > XATTR_MAX_VAL ? "..." : "");
>>   			return xattr;
>>   		}
>>   	}

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

