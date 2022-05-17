Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFC852A98F
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347630AbiEQRsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 13:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiEQRsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 13:48:07 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E10250062
        for <stable@vger.kernel.org>; Tue, 17 May 2022 10:48:06 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id f2so18730562wrc.0
        for <stable@vger.kernel.org>; Tue, 17 May 2022 10:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:cc:in-reply-to
         :content-transfer-encoding;
        bh=UPsLs/tl6fw8nGMQMq4qv68QHl+jISwr9iQW8lnZ56I=;
        b=ObEP5igKwSNp2AtVHqZt9jySxoG8Xp/KRm8kmhijjuDaNi98XRZc5wpEG9fcTEDX3G
         aUwF1ZtstIBnh6nvcAABALO7zMSp8EpkwUCnCz8j4OAYprjDdgLKbOHfliW23jM2hTAh
         aKAJA+tsNMlBJ9zJ4MJep0cilJFufeLnUljyFrrSuFvZfb63WYIWm+ORMpQJwN9vsKo/
         ewm4tkPnWgWh8aLbnYNOMjR3mVC9ORIigCjP+Nj2m9SB2ZBmT/JapgJMH+bDf3cJSod9
         8qHXfPXSCkqg+UZpUveX0mDMHNyvMlyeLW5va86VtS8V09UIvUlPmPeA0MGw3lM2r4SF
         Q55Q==
X-Gm-Message-State: AOAM532FCsukh/JxUTHDeQ1Q+abVGB+HN46nF8qcchsBwaS6h370smYY
        Jgb0oCBGt7Nbz/YMc8k/UmnYcmQWE3E=
X-Google-Smtp-Source: ABdhPJwFSr4g26qeDhOc5UJu6gdwaceOwUZw351Zd4vrkhTAXQUAggTiKrJ6whZJ9hYEnWRtKh+HEQ==
X-Received: by 2002:adf:ed01:0:b0:20c:c137:aaeb with SMTP id a1-20020adfed01000000b0020cc137aaebmr19930392wro.638.1652809684333;
        Tue, 17 May 2022 10:48:04 -0700 (PDT)
Received: from [10.5.230.100] ([91.74.65.58])
        by smtp.gmail.com with ESMTPSA id c13-20020adfa70d000000b0020c5253d8bfsm13101389wrd.11.2022.05.17.10.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 10:48:03 -0700 (PDT)
Message-ID: <236c0048-49b5-2c37-4549-d8774f243ae3@linux.com>
Date:   Tue, 17 May 2022 21:47:57 +0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/3] floppy: use a statically allocated error counter
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220508093709.24548-1-w@1wt.eu>
From:   Denis Efremov <efremov@linux.com>
Cc:     stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <20220508093709.24548-1-w@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/8/22 13:37, Willy Tarreau wrote:
> Interrupt handler bad_flp_intr() may cause a UAF on the recently freed
> request just to increment the error count. There's no point keeping
> that one in the request anyway, and since the interrupt handler uses
> a static pointer to the error which cannot be kept in sync with the
> pending request, better make it use a static error counter that's
> reset for each new request. This reset now happens when entering
> redo_fd_request() for a new request via set_next_request().
> 
> One initial concern about a single error counter was that errors on
> one floppy drive could be reported on another one, but this problem
> is not real given that the driver uses a single drive at a time, as
> that PC-compatible controllers also have this limitation by using
> shared signals. As such the error count is always for the "current"
> drive.
> 
> Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
> Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
> Tested-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Willy Tarreau <w@1wt.eu>

Could you please take this patch (only this one) to the stable trees?

commit f71f01394f742fc4558b3f9f4c7ef4c4cf3b07c8 upstream.

The patch applies cleanly to 5.17, 5.15, 5.10 kernels.
I'll send a backport for 5.4 and older kernels.

Thanks,
Denis

> ---
>  drivers/block/floppy.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index d5b9ff9bcbb2..015841f50f4e 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -509,8 +509,8 @@ static unsigned long fdc_busy;
>  static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
>  static DECLARE_WAIT_QUEUE_HEAD(command_done);
>  
> -/* Errors during formatting are counted here. */
> -static int format_errors;
> +/* errors encountered on the current (or last) request */
> +static int floppy_errors;
>  
>  /* Format request descriptor. */
>  static struct format_descr format_req;
> @@ -530,7 +530,6 @@ static struct format_descr format_req;
>  static char *floppy_track_buffer;
>  static int max_buffer_sectors;
>  
> -static int *errors;
>  typedef void (*done_f)(int);
>  static const struct cont_t {
>  	void (*interrupt)(void);
> @@ -1455,7 +1454,7 @@ static int interpret_errors(void)
>  			if (drive_params[current_drive].flags & FTD_MSG)
>  				DPRINT("Over/Underrun - retrying\n");
>  			bad = 0;
> -		} else if (*errors >= drive_params[current_drive].max_errors.reporting) {
> +		} else if (floppy_errors >= drive_params[current_drive].max_errors.reporting) {
>  			print_errors();
>  		}
>  		if (reply_buffer[ST2] & ST2_WC || reply_buffer[ST2] & ST2_BC)
> @@ -2095,7 +2094,7 @@ static void bad_flp_intr(void)
>  		if (!next_valid_format(current_drive))
>  			return;
>  	}
> -	err_count = ++(*errors);
> +	err_count = ++floppy_errors;
>  	INFBOUND(write_errors[current_drive].badness, err_count);
>  	if (err_count > drive_params[current_drive].max_errors.abort)
>  		cont->done(0);
> @@ -2241,9 +2240,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
>  		return -EINVAL;
>  	}
>  	format_req = *tmp_format_req;
> -	format_errors = 0;
>  	cont = &format_cont;
> -	errors = &format_errors;
> +	floppy_errors = 0;
>  	ret = wait_til_done(redo_format, true);
>  	if (ret == -EINTR)
>  		return -EINTR;
> @@ -2759,10 +2757,11 @@ static int set_next_request(void)
>  	current_req = list_first_entry_or_null(&floppy_reqs, struct request,
>  					       queuelist);
>  	if (current_req) {
> -		current_req->error_count = 0;
> +		floppy_errors = 0;
>  		list_del_init(&current_req->queuelist);
> +		return 1;
>  	}
> -	return current_req != NULL;
> +	return 0;
>  }
>  
>  /* Starts or continues processing request. Will automatically unlock the
> @@ -2821,7 +2820,6 @@ static void redo_fd_request(void)
>  		_floppy = floppy_type + drive_params[current_drive].autodetect[drive_state[current_drive].probed_format];
>  	} else
>  		probing = 0;
> -	errors = &(current_req->error_count);
>  	tmp = make_raw_rw_request();
>  	if (tmp < 2) {
>  		request_done(tmp);
