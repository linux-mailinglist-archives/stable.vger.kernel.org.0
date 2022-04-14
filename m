Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C70750181C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350261AbiDNQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353456AbiDNP5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:57:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1D109BB8B
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649951081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hqb8ahm9U2hYtvVT/EdGYzU5Sa+emRCVx8fikQB261Q=;
        b=GGujEJKkePaVoE2cN/qRZgAfK0ijweM0Pfgqt+kiruZNRjbeGamRFRiVg0qgjBkG31re8M
        5qMT7CQD4r4q4SgLsvchOAToyYvJjK9moMQsh6Qc/8a2uUe6RNJ1sSQB+LyphY+VvU7FQ4
        wJR0XHR8qED0arlyj1mCE6GIWrmWL1k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-mZHH7mEjN7exuZKavSJfmQ-1; Thu, 14 Apr 2022 11:44:35 -0400
X-MC-Unique: mZHH7mEjN7exuZKavSJfmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C28011014A7A;
        Thu, 14 Apr 2022 15:44:34 +0000 (UTC)
Received: from [10.22.19.30] (unknown [10.22.19.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF5E1111D3D1;
        Thu, 14 Apr 2022 15:44:33 +0000 (UTC)
Message-ID: <eda947e6-367a-9e7e-84cf-dee4a70a3b82@redhat.com>
Date:   Thu, 14 Apr 2022 11:44:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5] locking/rwsem: Make handoff bit handling more
 consistent
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     john.p.donnelly@oracle.com,
        chenguanyou <chenguanyou9338@gmail.com>, dave@stgolabs.net,
        hdanton@sina.com, linux-kernel@vger.kernel.org,
        mazhenhua@xiaomi.com, mingo@redhat.com, peterz@infradead.org,
        quic_aiquny@quicinc.com, will@kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
References: <20211116012912.723980-1-longman@redhat.com>
 <20220214154741.12399-1-chenguanyou@xiaomi.com>
 <3f02975c-1a9d-be20-32cf-f1d8e3dfafcc@oracle.com>
 <e873727e-22db-3330-015d-bd6581a2937a@redhat.com>
 <31178c33-e25c-c3e8-35e2-776b5211200c@oracle.com>
 <161c2e25-3d26-4dd7-d378-d1741f7bcca8@redhat.com>
 <2b6ed542-b3e0-1a87-33ac-d52fc0e0339c@oracle.com>
 <b3620b7b-c66a-65f8-b10b-c3669b2f82ec@redhat.com>
 <Ylf78yGuXdXWugpn@kroah.com>
 <d32d3036-a554-624b-0d3f-247539142273@redhat.com>
 <YlhA1IVb/MIox/Ik@kroah.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <YlhA1IVb/MIox/Ik@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/22 11:42, Greg KH wrote:
> On Thu, Apr 14, 2022 at 11:18:23AM -0400, Waiman Long wrote:
>> On 4/14/22 06:48, Greg KH wrote:
>>> On Tue, Apr 12, 2022 at 01:04:05PM -0400, Waiman Long wrote:
>>>> The patch has already been in the tip tree. It may not be easy to add a
>>>> Fixes tag to it. Anyway, I will encourage stable tree maintainer to take it
>>>> as it does fix a problem as shown in your test.
>>> I have no idea what you want me to do here.  Please be explicit...
>>>
>> I would like the stable trees to include commit 1ee326196c66
>> ("locking/rwsem: Always try to wake waiters in out_nolock path") after it is
>> merged into the mainline in the v5.19 merge window. It should be applied to
>> the stable trees that have incorporated the backport of commit d257cc8cb8d5
>> ("locking/rwsem: Make handoff bit handling more consistent") since this
>> commit seems to make the missed wakeup problem easier to show up.
> Please let us know when this is merged into Linus's tree.  Nothing we
> can do until then and I'm not going to remember this in a few months
> anyway.

Sure, I will remind you again after the merge happens.

Cheers,
Longman

