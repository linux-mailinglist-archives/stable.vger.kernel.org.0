Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A411859AEF5
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbiHTQD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 12:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344352AbiHTQD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 12:03:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5701D1D30C
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661011434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dk1zbtbPz6wFeKktH5u18CfghQGE/vszg2cVU5h0PNU=;
        b=QnwgELuMwCwPkf5O7M0JfexbXyI17IVkIDPSSyIjuZS78kUwIM8Y6VgDh9UnwjOVgIWI/U
        NtE/B9OrZBetrN1vCpIZNwm+6HLaesOt1X18peANouS/glZExDe9ke7meez0MRV5SqbPL1
        DqImv7JmsqymJrmtsalPPHmorqGuN7M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-N4TlRh6JNyaL8pFQZ5MCpg-1; Sat, 20 Aug 2022 12:03:50 -0400
X-MC-Unique: N4TlRh6JNyaL8pFQZ5MCpg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E275080029D;
        Sat, 20 Aug 2022 16:03:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2DC42026D4C;
        Sat, 20 Aug 2022 16:03:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 27KG3nT9015653;
        Sat, 20 Aug 2022 12:03:49 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 27KG3muE015649;
        Sat, 20 Aug 2022 12:03:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sat, 20 Aug 2022 12:03:48 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Pavel Machek <pavel@denx.de>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.15 089/779] md-raid10: fix KASAN warning
In-Reply-To: <20220819104534.GA11901@duo.ucw.cz>
Message-ID: <alpine.LRH.2.02.2208201202090.15558@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220815180337.130757997@linuxfoundation.org> <20220815180341.087873206@linuxfoundation.org> <20220819104534.GA11901@duo.ucw.cz>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, 19 Aug 2022, Pavel Machek wrote:

> Hi!
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > commit d17f744e883b2f8d13cca252d71cfe8ace346f7d upstream.
> > 
> > There's a KASAN warning in raid10_remove_disk when running the lvm
> > test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
> > value "number" is valid.
> > 
> > BUG: KASAN: slab-out-of-bounds in raid10_remove_disk+0x61/0x2a0 [raid10]
> > Read of size 8 at addr ffff889108f3d300 by task mdX_raid10/124682
> 
> Is this place for array_index_nospec?
> 
> Best regards,
> 								Pavel

Hi

I think it is not needed - userspace code can't trigger this code path at 
will.

Mikulas

