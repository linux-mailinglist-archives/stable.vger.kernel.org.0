Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027FD5EF51A
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 14:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiI2MSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 08:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiI2MSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 08:18:49 -0400
Received: from smtp-1908.mail.infomaniak.ch (smtp-1908.mail.infomaniak.ch [IPv6:2001:1600:4:17::1908])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2647212969F;
        Thu, 29 Sep 2022 05:18:47 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MdXTJ6ZzszMqJhl;
        Thu, 29 Sep 2022 14:18:44 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4MdXTJ1MvNzMpnPm;
        Thu, 29 Sep 2022 14:18:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1664453924;
        bh=W7vslApTCphM95MlDuIkNlTGmBG0MHn06s5FtT+q6n4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=J9t6XXTrSZ+jmXbM/e0FUaS26/80lkVy1/MDSHtzVr40GTEErjt8EmT4uN9Wo2Zty
         fl4wEiUCBr5fa9by5a+vLpZyXPchrmawM6hzuUmHEy8FhdryxNBStPZjDs4BaH5tfC
         i6+hIILR6z4dw3J5UeBXe9xWN/ZAqYWPzBEck+iU=
Message-ID: <75d077ca-4f1d-50c4-10d2-0fb31fcd0c86@digikod.net>
Date:   Thu, 29 Sep 2022 14:18:43 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v1] ksmbd: Fix user namespace mapping
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
References: <20220929100447.108468-1-mic@digikod.net>
 <20220929113735.7k6fdu75oz4jvsvz@wittgenstein>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220929113735.7k6fdu75oz4jvsvz@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/09/2022 13:37, Christian Brauner wrote:
> On Thu, Sep 29, 2022 at 12:04:47PM +0200, Mickaël Salaün wrote:
>> A kernel daemon should not rely on the current thread, which is unknown
>> and might be malicious.  Before this security fix,
>> ksmbd_override_fsids() didn't correctly override FS UID/GID which means
>> that arbitrary user space threads could trick the kernel to impersonate
>> arbitrary users or groups for file system access checks, leading to
>> file system access bypass.
>>
>> This was found while investigating truncate support for Landlock:
>> https://lore.kernel.org/r/CAKYAXd8fpMJ7guizOjHgxEyyjoUwPsx3jLOPZP=wPYcbhkVXqA@mail.gmail.com
>>
>> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Link: https://lore.kernel.org/r/20220929100447.108468-1-mic@digikod.net
>> ---
> 
> I think this is ok. The alternative would probably be to somehow use a
> relevant userns when struct ksmbd_user is created when the session is
> established. But these are deeper ksmbd design questions. The fix
> proposed here itself seems good.

That would be better indeed. I guess ksmbd works whenever the netlink 
peer is not in a user namespace with mapped UID/GID, but it should 
result in obvious access bugs otherwise (which is already the case 
anyway). It seems that the netlink peer must be trusted because it is 
the source of truth for account/user mapping anyway. This change fixes 
the more critical side of the issue and it should fit well for backports.
