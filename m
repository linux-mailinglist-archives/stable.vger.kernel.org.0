Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166E86E26C3
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 17:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjDNPWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjDNPWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 11:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94A05FDE
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 08:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681485715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdbEwiahBwBXRaQHbJvtM9eClPW37i0c/e8eWpmB8cw=;
        b=cgaqkWnEw7wcrNfd0Sc59BzlMnB3nPbkyxqVEE7YT3YLb55cnSBAOWpA28it/yRxc2g1Zb
        N2hswvAtpylnd64T1C1g3IFv6GohiqoMI9bLWN8JOcGJq/3Jz7VSavxNSFNV8qd+MEwnS4
        VZcZveoBNXIx8Ym8nvarVRJWQIWstfM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-N31LnfT9O5axtNl1y19qKg-1; Fri, 14 Apr 2023 11:21:53 -0400
X-MC-Unique: N31LnfT9O5axtNl1y19qKg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-74ad69ad9a1so20280385a.0
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 08:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681485713; x=1684077713;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zdbEwiahBwBXRaQHbJvtM9eClPW37i0c/e8eWpmB8cw=;
        b=ReLF+eDEA8/2SeWbOb/w2o3fmpnP7eAMvudQw1+MFjs7R0hVbpWaMrYeQ4ZDeSVQKi
         zmHpVc+L1gocBtfqzZpL4zzKgSbOFHQFuwSl6UkB8/x5VVBpKr+xQySVMOPqZV+0YvOL
         qLPZ2bO83euaqYkIYXCnwLj63eWw26+rLeCjKaNxRZqjGTXqpzjHxfQOHirwdyvNYWoA
         WUourtRUxXKnBlcMGR8su5NhEamt1uX8bF2pmtlSEuZFpGwn7mgrqMnyqLYa+0g0DPoS
         cdKCv4cQ9bwLV9Eu41qRgQX84kcyLIUUtK0ueozI5d6sFO2rzjAtl1jo+JkNuAO1I+mr
         ZN1Q==
X-Gm-Message-State: AAQBX9d09pe2sBZqG06rVf2WcUMt7l6hY5PDtPbzrHGDcF+yIWjYrWtA
        CE9bEX2j59kd/0P/OPDzg/MyTPWDYt1nQnAI2geWhqliByWn+U1DrwPAWdZBKkWSe8SvqwCEVJ4
        DuRFL57G07ajDInFb
X-Received: by 2002:a05:6214:3001:b0:5ac:463b:a992 with SMTP id ke1-20020a056214300100b005ac463ba992mr4105658qvb.0.1681485712851;
        Fri, 14 Apr 2023 08:21:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350YVMekG3fi9eYn45rlgF4IHcf6ljNGAcY26V2wE8u/UOoyEqKIJi7gtK1xsqy+LkNdk+7QsnQ==
X-Received: by 2002:a05:6214:3001:b0:5ac:463b:a992 with SMTP id ke1-20020a056214300100b005ac463ba992mr4105629qvb.0.1681485712554;
        Fri, 14 Apr 2023 08:21:52 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id ly7-20020a0562145c0700b005eb1611872asm1173774qvb.83.2023.04.14.08.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:21:51 -0700 (PDT)
Date:   Fri, 14 Apr 2023 11:21:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm/hugetlb: Fix uffd-wp during fork()
Message-ID: <ZDlvjlcTXOyFTdaA@x1n>
References: <20230413231120.544685-1-peterx@redhat.com>
 <20230413231120.544685-2-peterx@redhat.com>
 <9cb84b60-6b51-3117-27cb-a29b3bd9e741@mbosol.com>
 <ZDlet0+oZ2nrnUdu@x1n>
 <d14ddbc6-5315-78a2-cdfa-72a77d3603dd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d14ddbc6-5315-78a2-cdfa-72a77d3603dd@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 05:23:12PM +0300, Mika Penttilä wrote:
> But the fixup not dropping the temp var should work.

Ok I see.  I'll wait for a few more days for a respin.  Thanks,

-- 
Peter Xu

