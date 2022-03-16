Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78AF4DB36C
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356706AbiCPOjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356490AbiCPOjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:39:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1A4F3981B
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647441491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4pZBLggxKdz4L37gBgUJARXj4G+el7mKfdePMsD8X+U=;
        b=jLe8Qyzo65quyyFh6J1IkCIS5GJZ5tKHKhKFrybRcl8RruwZtJ7W75jq2L8paCvMrOkMhO
        N1UIMgzYv1HFgTwTHckSkPJ9J7tGhcEIgJ9eAXcT5PPzJpr8uYpoKf7aU1CBpF7e5CgcLP
        pWuAbshEirzVQwcetFj9gns6MHIUc8g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-m5rIbwTQNDeiO5ku6RDWHA-1; Wed, 16 Mar 2022 10:38:06 -0400
X-MC-Unique: m5rIbwTQNDeiO5ku6RDWHA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 982AE85A5BE;
        Wed, 16 Mar 2022 14:38:05 +0000 (UTC)
Received: from [10.18.17.215] (dhcp-17-215.bos.redhat.com [10.18.17.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 224F9432470;
        Wed, 16 Mar 2022 14:38:04 +0000 (UTC)
Message-ID: <ee1e2ab4-c498-c047-ad70-fc46b508fe74@redhat.com>
Date:   Wed, 16 Mar 2022 10:38:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: apply commit 61cc4534b655 ("locking/lockdep: Avoid potential
 access of invalid memory in lock_class") to linux-5.4-stable
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-mediatek@lists.infradead.org,
        Eason-YH Lin <eason-yh.lin@mediatek.com>
References: <6eb2052f463d323b0a82e795d765afb9d5925f6e.camel@mediatek.com>
 <YjHzl3Arey7KH0CB@kroah.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <YjHzl3Arey7KH0CB@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/16/22 10:26, Greg KH wrote:
> On Wed, Mar 16, 2022 at 02:01:12PM +0800, Cheng Jui Wang wrote:
>> Hi Reviewers,
>>
>> This patch fixes a use-after-free error when /proc/lockdep is read by
>> user after a lockdep splat.
>>
>> I checked and I think this patch can be applied to stable-5.4 and
>> later.
>>
>> commit: 61cc4534b6550997c97a03759ab46b29d44c0017
>> Subject: locking/lockdep: Avoid potential access of invalid memory in
>> lock_class
> I do not see that commit id in Linus's tree, are you sure it is correct?

This commit is currently in the tip tree. It have not been merged into 
the mainline yet, though it should happen in the upcoming merge window.

Cheers,
Longman

