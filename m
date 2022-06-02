Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B42D53BDCE
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiFBSOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 14:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiFBSOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 14:14:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFCA2BF0
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 11:14:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so5154155plg.5
        for <stable@vger.kernel.org>; Thu, 02 Jun 2022 11:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2hzKsxy3GSyzH3VoPq74Ra2M46bw5Ap28I/rHJv3+tc=;
        b=rq2vHBiEC8VMhleqYRJItNirIKM61m3R7HxvIwMhcznlxp4rEHQLbZvFoIRBA+QhAN
         H0xw5egFOCZE+Dj/U7jrX6ZCAiErSQ9XG8+OuIb714LahEBjSPGFU6QlBBOxLn7sKQ1c
         d8N4FSsRwf7+Bah9rO0E5GgBJAY/gRFchcen13kA74EDDkHFXv+pXOn6W3LAT9rOJziR
         +ZXdXVyLaMKYOwyJOdreyvSHckjLLSJaXYEvo511Dvew34ecpL+/cqclBF8f40xwqZtg
         Y+0arLu4Fsx9+DmK4w/i3K7GSUI/GT9P5pi9LRAdGLpn+dROFGSHvmDvG2HBiZHLKV1z
         eznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hzKsxy3GSyzH3VoPq74Ra2M46bw5Ap28I/rHJv3+tc=;
        b=QuNYGVOwSXejc7A3ui/Ah876tUFJr1vlQWTombAw+6i9kcEsA7LbxWxHiMDk9QFdc+
         4c9weuxl5F9r3lCJEpTQ9rZXU6qdwBcPNksMr0HfjBaMPHzl6rO8sNSuZUyvLmKx8IrU
         XmNqdHksMmocgPjeCSDEAl61XMI9etqsBXIuhUA2Z5/6av9bJJ3XXMzAmD0yF2MLnI3y
         /24RJc+55B1lQt4lbRspTK/UBFZhDEFwIm9H51bM9U3z94JoAcl7uJASa2C3l+qbcsAD
         Er5t02tCxXTm8LFTs11YyU4y46+P4UVpKJZxwK72DA8EARoGp1fAaEwAQd2CGNU10yBi
         KsqA==
X-Gm-Message-State: AOAM533+LgvuH6r55ZX/3qkPDoCzVLm2YBgiB7qfBK1YDh4up8OVn9+b
        gIATwDNS4RVFTVclU4QVqJRbn9NA3Qi29g==
X-Google-Smtp-Source: ABdhPJwxo235xizUNRexwPvS8t+xM23zzOIJMb4n64zyUc5d3kEkj6ZgoqLvyhOL613HmfHYlNNQ5Q==
X-Received: by 2002:a17:903:240e:b0:158:eab9:2662 with SMTP id e14-20020a170903240e00b00158eab92662mr6067700plo.87.1654193645056;
        Thu, 02 Jun 2022 11:14:05 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79987000000b005104c6d7941sm3921224pfh.31.2022.06.02.11.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 11:14:04 -0700 (PDT)
Date:   Thu, 2 Jun 2022 11:14:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <20220602111401.31bcbe35@hermes.local>
In-Reply-To: <20220602105215.12aff895@kernel.org>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
        <20220601180147.40a6e8ea@kernel.org>
        <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
        <20220602085645.5ecff73f@hermes.local>
        <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
        <20220602095756.764471e8@kernel.org>
        <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
        <20220602105215.12aff895@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 Jun 2022 10:52:15 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 2 Jun 2022 17:15:13 +0000 Joakim Tjernlund wrote:
> > > What is "our HW", what kernel driver does it use and why can't the
> > > kernel driver take care of making sure the device is not accessed
> > > when it'd crash the system?    
> > 
> > It is a custom asic with some homegrown controller. The full config path is too complex for kernel too
> > know and depends on user input.  
> 
> We have a long standing tradition of not caring about user space
> drivers in netdev land. I see no reason to merge this patch upstream.
> 
> > > > Maybe so but it seems to me that this limitation was put in place without much thought.    
> > > 
> > > Don't make unnecessary disparaging statements about someone else's work.
> > > Whoever that person was.    
> > 
> > That was not meant the way you read it, sorry for being unclear.
> > The commit from 2012 simply says:
> > net: allow to change carrier via sysfs
> >     
> >     Make carrier writable  
> 
> Yeah, IIUC the interface was created for software devices.

If you want to discussion of original patch see:
https://patchwork.ozlabs.org/project/netdev/patch/1314715608-978-2-git-send-email-jpirko@redhat.com/

PS: if you have lots of userspace handling, you should be using netlink not sysfs for management
