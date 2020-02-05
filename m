Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718551526CA
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 08:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgBEHWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 02:22:31 -0500
Received: from seldsegrel01.sonyericsson.com ([37.139.156.29]:17277 "EHLO
        SELDSEGREL01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgBEHWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 02:22:31 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2020 02:22:30 EST
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jiri Kosina <jkosina@suse.cz>
CC:     <stable@vger.kernel.org>,
        <syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <20200114094356.028051662@linuxfoundation.org>
From:   peter enderborg <peter.enderborg@sony.com>
Message-ID: <27ba705a-6734-9a92-a60c-23e27c9bce6d@sony.com>
Date:   Wed, 5 Feb 2020 08:12:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114094356.028051662@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-SEG-SpamProfiler-Analysis: v=2.3 cv=V88DLtvi c=1 sm=1 tr=0 a=T5MYTZSj1jWyQccoVcawfw==:117 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=l697ptgUJYAA:10 a=hSkVLCK3AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=mkI5n4lM7TqXLe6ThCMA:9 a=QEXdDO2ut3YA:10 a=cQPPKAXgyycSBL8etih5:22 a=AjGcO6oz07-iQ99wixmX:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-SEG-SpamProfiler-Score: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/20 11:00 AM, Greg Kroah-Hartman wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
>
> commit 8ec321e96e056de84022c032ffea253431a83c3c upstream.
>
> The syzbot fuzzer found a slab-out-of-bounds bug in the HID report
> handler.  The bug was caused by a report descriptor which included a
> field with size 12 bits and count 4899, for a total size of 7349
> bytes.
>
> The usbhid driver uses at most a single-page 4-KB buffer for reports.
> In the test there wasn't any problem about overflowing the buffer,
> since only one byte was received from the device.  Rather, the bug
> occurred when the HID core tried to extract the data from the report
> fields, which caused it to try reading data beyond the end of the
> allocated buffer.
>
> This patch fixes the problem by rejecting any report whose total
> length exceeds the HID_MAX_BUFFER_SIZE limit (minus one byte to allow
> for a possible report index).  In theory a device could have a report
> longer than that, but if there was such a thing we wouldn't handle it
> correctly anyway.
>
> Reported-and-tested-by: syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: <stable@vger.kernel.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/hid/hid-core.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -288,6 +288,12 @@ static int hid_add_field(struct hid_pars
>  	offset = report->size;
>  	report->size += parser->global.report_size * parser->global.report_count;
>  
> +	/* Total size check: Allow for possible report index byte */
> +	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
> +		hid_err(parser->device, "report is too long\n");
> +		return -1;
> +	}
> +
>  	if (!parser->local.usage_index) /* Ignore padding fields */
>  		return 0;
>  
>
>
>
This patch breaks Elgato StreamDeck.

