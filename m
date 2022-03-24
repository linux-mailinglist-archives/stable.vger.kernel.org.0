Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EBC4E5C59
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 01:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243273AbiCXAeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 20:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbiCXAd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 20:33:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3291086E17;
        Wed, 23 Mar 2022 17:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=CGXuE/lh/IrI3wTXY2imcHRR1CWO7A2UB3AXJZe0yPU=; b=H6YkGvSdL3i5Np/sjN9nrLYU16
        tgwaU1xiF9MHuVvyQGnDUh8UMxbuIZyBwnAlH6U7O/fEpFO4SrtCojq86kbmeR9HWjXzhFXlBfCqA
        3XqZ3iG1IxrBTTnHtw4MPEngJjWo3V6MqXmXZkf/f3XNwob5aWWFzH5MJL0rIIdp9DUhO8w5kefnv
        0epm1H/8q3WVKhNaFr2hi8s8tDL8h9pG5Oc50JFNmXfaEA/HaNSfjggfNh19RsJQBjaSDQpHBodsZ
        ssvVcYb1xzD/5IYZnne4mYoOOH9pEmQrWjjLgLu8tqURdUVEhJsAn+WskrmB+HHggxLPwoo7AGmf6
        WFIyLjf9TK4QhNcMx3dy34QxffMLYVI6QMEsJ50Rc0GfVMvuyaq341nr1W0+j5A0m7yCTEbvrsXlu
        MdY5ePB2sLvlAXbzhNjqOK1e7wzxnVckNwWae7HrUSeTpkPqVZHN8fJqNLnf16OeufPG3ZjsbUolp
        0TMQilG59+v4PUQkU7Ru+ScY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nXBOq-0038Tj-I0; Thu, 24 Mar 2022 00:32:24 +0000
Message-ID: <51a79835-9186-695c-0304-bfd6e6a5d17d@samba.org>
Date:   Thu, 24 Mar 2022 01:32:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, stable@vger.kernel.org
References: <20220323224131.370674-1-axboe@kernel.dk>
 <20220323224131.370674-2-axboe@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
In-Reply-To: <20220323224131.370674-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens,

> @@ -5524,12 +5542,22 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>   			return -EAGAIN;
>   		if (ret == -ERESTARTSYS)
>   			ret = -EINTR;
> +		if (ret > 0 && io_net_retry(sock, flags)) {
> +			sr->len -= ret;
> +			sr->buf += ret;
> +			sr->done_io += ret;
> +			return -EAGAIN;
> +		}
>   		req_set_fail(req);
>   	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
>   out_free:
>   		req_set_fail(req);

The change only affects retry based socket io in the main thread, correct?

The truncated mesages still trigger req_set_fail if MSG_WAITALL was set?

metze

