Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B61611EEB
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 03:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJ2BMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 21:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJ2BMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 21:12:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0DB1D4406
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 18:12:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36810cfa61fso56532557b3.6
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 18:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzirdpB8o7lNjReftiX3IOzTMZDA49bnUBUpRIMEVz0=;
        b=C93TkHor9sG0YrHfYCanrmTbr1ODnssibkMka1CDdjSvu/Qja9+NGxHoPnFObXxZvE
         GXBANvCg8hYyoao1XJVZQcDuYYKL3hCl8JXwsqfVxvL5RGQoQEjXofWQ+Phej/FE+w2e
         LM1CCTLbcoxR07mSo8W16zyQ2RRKK5zYAr+dhHIi+eRCHCoJ0CHm8U1iRpIhtclDx4bb
         8Bily9FTWUVI93SfVVaif881wa60XSf+Z01xAPviPLn3AadgiNLvr78hrkA8+50Uzft7
         8bQ01D7IZ7MVtWs2x5HmKBUo5DugGQadbsn2wzjW4nzOsWY7RyFSH+2r9cffzygQ9G63
         tZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzirdpB8o7lNjReftiX3IOzTMZDA49bnUBUpRIMEVz0=;
        b=jR8UwKMKw89o1q9MNi+11tvT8BsnQS8LW6VX/phTa790wTUvV4BFHJ39IdRjC91hne
         24BLlAj3h0lGT0Zd9RbXaNgwYpAgAX57GX1emUXlTX2zlAbE8o7DawnbFyv3kAYxqb+7
         sUxnFnzeBIBP5+2KicP0SGKEU1uTS4hzaTq/XrChaCGskoa3SJID5ZueMWPU9e6wdyOl
         dS6ihbp+v5WhMQQV+poX9sJ7Oqxw2gk0v571xeGulxvFWHoO+nTeKX72mCn6mhC/VDP3
         nqLi30z0fUGCLf3F+7AzhTSCJ81IWeCF7Z68jsRHRyu0qC4lBiywURTvurrYUtnzrpaC
         6sXA==
X-Gm-Message-State: ACrzQf3PVEu8LVs8kUsCdLhJoVwhSQDNHUhGATRjvK0LNHPdz78pPn5b
        5HNbxUG9BVCFZId3ILYxMMBCd1w=
X-Google-Smtp-Source: AMsMyM5RXioXywasRw0IgKj7UP/UyG6hzkhBW1Tx1dbhUjNNBTnBYoZ2bxTSGEieY+mK+qbB9WXTh5o=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a05:6902:1608:b0:6cb:75a6:7656 with SMTP id
 bw8-20020a056902160800b006cb75a67656mr1722714ybb.223.1667005934151; Fri, 28
 Oct 2022 18:12:14 -0700 (PDT)
Date:   Sat, 29 Oct 2022 01:12:11 +0000
In-Reply-To: <20221024113005.376059449@linuxfoundation.org>
Mime-Version: 1.0
References: <20221024113005.376059449@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221029011211.4049810-1-ovt@google.com>
Subject: Re: [PATCH 5.4 086/255] once: add DO_ONCE_SLOW() for sleepable contexts
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     gregkh@linuxfoundation.org
Cc:     christophe.leroy@csgroup.eu, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

This commit causes the following panic in kernel built with clang
(GCC build is not affected): 

[    8.320308] BUG: unable to handle page fault for address: ffffffff97216c6a                                        [26/4066]
[    8.330029] #PF: supervisor write access in kernel mode                                                                    
[    8.337263] #PF: error_code(0x0003) - permissions violation 
[    8.344816] PGD 12e816067 P4D 12e816067 PUD 12e817063 PMD 800000012e2001e1                                                 
[    8.354337] Oops: 0003 [#1] SMP PTI                
[    8.359178] CPU: 2 PID: 437 Comm: curl Not tainted 5.4.220 #15                                                             
[    8.367241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015                                   
[    8.378529] RIP: 0010:__do_once_slow_done+0xf/0xa0   
[    8.384962] Code: 1b 84 db 74 0c 48 c7 c7 80 ce 8d 97 e8 fa e9 4a 00 84 db 0f 94 c0 5b 5d c3 66 90 55 48 89 e5 41 57 41 56 
53 49 89 d7 49 89 f6 <c6> 07 01 48 c7 c7 80 ce 8d 97 e8 d2 e9 4a 00 48 8b 3d 9b de c9 00                                      
[    8.409066] RSP: 0018:ffffb764c02d3c90 EFLAGS: 00010246
[    8.415697] RAX: 4f51d3d06bc94000 RBX: d474b86ddf7162eb RCX: 000000007229b1d6                                              
[    8.424805] RDX: 0000000000000000 RSI: ffffffff9791b4a0 RDI: ffffffff97216c6a                                              
[    8.434108] RBP: ffffb764c02d3ca8 R08: 0e81c130f1159fc1 R09: 1d19d60ce0b52c77                                              
[    8.443408] R10: 8ea59218e6892b1f R11: d5260237a3c1e35c R12: ffff9c3dadd42600                                              
[    8.452468] R13: ffffffff97910f80 R14: ffffffff9791b4a0 R15: 0000000000000000                                            
[    8.461416] FS:  00007eff855b40c0(0000) GS:ffff9c3db7a80000(0000) knlGS:0000000000000000                                   
[    8.471632] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                              
[    8.478763] CR2: ffffffff97216c6a CR3: 000000022ded0000 CR4: 00000000000006a0                                              
[    8.487789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                              
[    8.496684] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400                                              
[    8.505443] Call Trace:                                                                                                    
[    8.508568]  __inet_hash_connect+0x523/0x530                                                                               
[    8.513839]  ? inet_hash_connect+0x50/0x50                                                                                 
[    8.518818]  ? secure_ipv4_port_ephemeral+0x69/0xe0
[    8.525003]  tcp_v4_connect+0x2c5/0x410
[    8.529858]  __inet_stream_connect+0xd7/0x360
[    8.535329]  ? _raw_spin_unlock+0xe/0x10
... skipped ...


The root cause is the difference in __section macro semantics between 5.4 and
later LTS releases. On 5.4 it stringifies the argument so the ___done
symbol is created in a bogus section ".data.once", with double quotes:

% readelf -S vmlinux | grep data.once
  [ 5] ".data.once"      PROGBITS         ffffffff82216c6a  01416c6a
