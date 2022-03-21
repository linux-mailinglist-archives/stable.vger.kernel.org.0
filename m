Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E9A4E33D0
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiCUXFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiCUXEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:04:43 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5BE3DABFC
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 15:50:52 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-de3ca1efbaso242837fac.9
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=zSo+YHCVxkrIG4d4JGw6c/ZiUBVFVKc+agJDZsQcIME=;
        b=oGe0dSOnKWmRVLz15bMXE5vxggepQAjQnLIJvUtzUph/olLrexTh9fjie3ebb1fKtg
         3pmqmccKR8QaY8Tap/jA5GK8Tz8YaUQeXJ8hxdEtE5J2JFwkTrEOpV612jhe0lBu/1JU
         PQTBWDF3JhS4rvd1VoJjl9DqgiHev9AUt7MAGBwzOlzTPEWCydFDnOBK2eIoTGh7njn6
         jsnFci9MZSMXYd6hMvsPjTphfikeDwRPT3kDCKQItgBKoQUcEvHx8P7t8QFnHvmeIcDx
         YA9FcXHVeiqkR6TlddO/hr+Z2CzfDxjrf8uiyANmVGbj1Q/7QaGpAlMylz7wT9tr4MMO
         0dvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=zSo+YHCVxkrIG4d4JGw6c/ZiUBVFVKc+agJDZsQcIME=;
        b=w68t9YzYZitLo2wI0ea6hIccADLYoN4Bn75Eavy+dEMIkdmnCNr8sGn7K4PPms3KcZ
         aY5gb0GKIiHqU4nZy1pQhNm4oLaFg9+ltgjb3kMPuTjOXpq0NfnTOn06XTPAjgTUsFPG
         KZPB3iNc1SCKGwOMcafI0uD1RSH+l9PDHt0W8W7gXt2F78RDtdRy2x32sxX1SSOrhGvd
         Tsy5UI96Vghm+uFHnLKDh8vcHbvZnLytJL8CHSNmr5fuFMxglBKrvwd6GJMpFRJGLg3P
         QVusq7vnk5zRo5wjC6bMW12DCgEMlXS3eQS8ihBefjBtLkhoNR0EtR0Bj4f5JOEkPzM1
         5HuA==
X-Gm-Message-State: AOAM531O6wthQ5A6npOd7PFehlhqIrcet7UVXgEGA6QdfdaY124bL8a2
        3HKHmlOWeOdbRU5lZx3eFWdin+4tvtE=
X-Google-Smtp-Source: ABdhPJxOzcE266CBA14W70J7wpzX6gRly823cuhm871czv1C3UQIzObhNMTvAjZdLEmukLASXjBoZw==
X-Received: by 2002:a17:90a:9dc6:b0:1bc:5c73:522b with SMTP id x6-20020a17090a9dc600b001bc5c73522bmr1266735pjv.35.1647899155210;
        Mon, 21 Mar 2022 14:45:55 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm21290725pfw.188.2022.03.21.14.45.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 14:45:54 -0700 (PDT)
Message-ID: <fd794879-48d6-463a-fe0f-184df7cc66d2@gmail.com>
Date:   Mon, 21 Mar 2022 14:45:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Backport Request: scsi: lpfc: Fix DMA virtual address ptr assignment
 in bsg
Content-Language: en-US
From:   James Smart <jsmart2021@gmail.com>
To:     stable <stable@vger.kernel.org>
References: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
In-Reply-To: <6aab7d93-7791-fd8b-b0ed-6a0a2ee52472@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please backport the following patch to the 5.10 stable kernel. It is was 
upstream'd as of the 5.12 kernel.

scsi: lpfc: Fix DMA virtual address ptr assignment in bsg
commit    83adbba746d1

The error causes diagnostic loopback tests to fail.

Note: problem was introduced in 5.10 by:
   scsi: lpfc: Reject CT request for MIB commands
   commit b67b59443282


-- James

