Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BA010A817
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 02:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfK0BtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 20:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfK0BtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 20:49:24 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A50102071E;
        Wed, 27 Nov 2019 01:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574819363;
        bh=pz61DF7bIXRjkqUZiIfU6KbYdU//cTWOBjWQEIOXfIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kvI9DQwhrGxeaUT2KQh+3MUmJbpdqDmFB+2T6Iv3sexmtqMUMYv7XkAdb02KQlnjE
         vn0uWQwjdhdvFRjkuUNnuGt1rBCkCPT3RrbycMnIuSZZnIAnTFSTA+WVqv4LcqhRqY
         8SJtsAI0tB+sJJKFOEojE0FHCZS8y36l7LPEXuPw=
Date:   Tue, 26 Nov 2019 20:49:22 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     gregkh@linuxfoundation.org, vcaputo@pengaru.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "dm crypt: use WQ_HIGHPRI for the
 IO and crypt" failed to apply to 4.14-stable tree
Message-ID: <20191127014922.GK5861@sasha-vm>
References: <1574764864161192@kroah.com>
 <20191126170755.GB2718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191126170755.GB2718@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 12:07:55PM -0500, Mike Snitzer wrote:
>On Tue, Nov 26 2019 at  5:41am -0500,
>gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
>
>>
>> The patch below does not apply to the 4.14-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>
>Same as 4.19 goes for 4.14, this worked for me:
>
>git cherry-pick ed0302e83098d
>git cherry-pick f612b2132db529feac4f965f28a1b9258ea7c22b

$ git cherry-pick ed0302e83098d
[queue-4.19 fa98ce88d51b9] dm crypt: make workqueue names device-specific
 Author: Michał Mirosław <mirq-linux@rere.qmqm.pl>
 Date: Tue Oct 9 22:13:43 2018 +0200
 1 file changed, 10 insertions(+), 5 deletions(-)
$ git cherry-pick f612b2132db529feac4f965f28a1b9258ea7c22b
[queue-4.19 73eb292b80f32] Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues"
 Author: Mike Snitzer <snitzer@redhat.com>
 Date: Wed Nov 20 17:27:39 2019 -0500
 1 file changed, 3 insertions(+), 6 deletions(-)
$ make allmodconfig
scripts/kconfig/conf  --allmodconfig Kconfig
#
# configuration written to .config
#
$ make drivers/md/dm-crypt.o
scripts/kconfig/conf  --syncconfig Kconfig
  CALL    scripts/checksyscalls.sh
  DESCEND  objtool
  CC [M]  drivers/md/dm-crypt.o
drivers/md/dm-crypt.c: In function ‘crypt_ctr’:
drivers/md/dm-crypt.c:2674:24: error: implicit declaration of function ‘dm_table_device_name’; did you mean ‘dm_device_name’? [-Werror=implicit-function-declaration]
  const char *devname = dm_table_device_name(ti->table);
                        ^~~~~~~~~~~~~~~~~~~~
                        dm_device_name
drivers/md/dm-crypt.c:2674:24: warning: initialization of ‘const char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
cc1: some warnings being treated as errors
make[1]: *** [scripts/Makefile.build:310: drivers/md/dm-crypt.o] Error 1
make: *** [Makefile:1678: drivers/md/dm-crypt.o] Error 2

-- 
Thanks,
Sasha
